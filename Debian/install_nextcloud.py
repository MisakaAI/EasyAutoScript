#!/usr/bin/env python3
from __future__ import annotations
import os
import re
import shutil
import stat
import subprocess
import sys
import tempfile
from io import BytesIO
from pathlib import Path
from PIL import Image

# ============================================================
# 配置
# ============================================================
HOME = Path.home()
CURRENT_DIR = Path.cwd()
APP_DIR = HOME / "Applications"
APPIMAGE = APP_DIR / "Nextcloud.AppImage"
# 当前目录中自动寻找，例如：
# Nextcloud-34.0.3-x86_64.AppImage
SOURCE_PATTERN = "Nextcloud-*-x86_64.AppImage"
ICON_BASE = HOME / ".local/share/icons/hicolor"
ICON_NAME = "nextcloud-appimage"
DESKTOP_DIR = HOME / ".local/share/applications"
DESKTOP_FILE = DESKTOP_DIR / "nextcloud-appimage.desktop"
# 从 AppImage 图标向下生成这些尺寸。
ICON_SIZES = [
    16,
    22,
    24,
    32,
    48,
    64,
    128,
    192,
    256,
]


# ============================================================
# 输出辅助
# ============================================================
def section(title: str) -> None:
    print()
    print("=" * 68)
    print(title)
    print("=" * 68)


# ============================================================
# 1. 安装 AppImage
# ============================================================
def find_source_appimage() -> Path | None:
    """
    在当前目录寻找 Nextcloud-*-x86_64.AppImage。
    如果没有找到，但 ~/Applications/Nextcloud.AppImage 已存在，
    则允许脚本重复执行。
    """
    candidates = sorted(
        path for path in CURRENT_DIR.glob(SOURCE_PATTERN) if path.is_file()
    )
    if len(candidates) > 1:
        files = "\n".join(f"  {path.name}" for path in candidates)
        raise RuntimeError(
            f"当前目录找到多个 Nextcloud AppImage，无法确定应该安装哪一个：\n{files}"
        )
    if len(candidates) == 1:
        return candidates[0]
    return None


def install_appimage() -> None:
    section("1. 安装 Nextcloud AppImage")
    APP_DIR.mkdir(
        parents=True,
        exist_ok=True,
    )
    source = find_source_appimage()
    if source is not None:
        print(f"找到 AppImage：{source}")
        print(f"安装到：       {APPIMAGE}")
        # 已存在旧版时覆盖。
        if APPIMAGE.exists() or APPIMAGE.is_symlink():
            if APPIMAGE.is_dir() and not APPIMAGE.is_symlink():
                raise RuntimeError(f"目标路径是目录，拒绝覆盖：{APPIMAGE}")
            print(f"删除旧版本：   {APPIMAGE}")
            APPIMAGE.unlink()
        try:
            # 同一文件系统优先 rename。
            source.replace(APPIMAGE)
        except OSError:
            # 跨文件系统退回 shutil.move。
            shutil.move(
                str(source),
                str(APPIMAGE),
            )
        print("AppImage 已移动并改名。")
    elif APPIMAGE.is_file():
        print("当前目录没有新的 Nextcloud AppImage，继续使用已经安装的版本：")
        print(f"  {APPIMAGE}")
    else:
        raise FileNotFoundError(
            "没有找到 Nextcloud AppImage。\n"
            f"请把类似下面的文件放在当前目录：\n"
            f"  Nextcloud-34.0.3-x86_64.AppImage\n"
            f"匹配规则：\n"
            f"  {SOURCE_PATTERN}"
        )
    # 添加可执行权限。
    mode = APPIMAGE.stat().st_mode
    APPIMAGE.chmod(mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)
    print("可执行权限：   OK")


# ============================================================
# 2. 获取实际版本
# ============================================================
def detect_nextcloud_version() -> str:
    section("2. 检测 Nextcloud 版本")
    try:
        result = subprocess.run(
            [
                str(APPIMAGE),
                "--version",
            ],
            text=True,
            capture_output=True,
            timeout=30,
        )
    except Exception as exc:
        print(
            f"警告：无法执行 --version：{exc}",
            file=sys.stderr,
        )
        return "unknown"
    output = ((result.stdout or "") + (result.stderr or "")).strip()
    if output:
        print(output)
    match = re.search(
        r"Nextcloud\s+version\s+"
        r"([0-9][0-9A-Za-z.+~_-]*)",
        output,
        re.IGNORECASE,
    )
    if not match:
        print(
            "\n警告：无法解析版本号。",
            file=sys.stderr,
        )
        return "unknown"
    version = match.group(1)
    print()
    print(f"检测到 Nextcloud 版本：{version}")
    return version


# ============================================================
# 3. 从 AppImage 提取图标
# ============================================================
def find_extracted_icon(extracted_root: Path) -> Path:
    """
    按 AppImage 常见布局寻找 Nextcloud 自带的图标。

    Nextcloud 官方 AppImage 通常同时包含 .DirIcon、根目录
    Nextcloud.png，以及 usr/share/icons 下的标准图标。
    """
    preferred_paths = (
        extracted_root / ".DirIcon",
        extracted_root / "Nextcloud.png",
        extracted_root / "usr/share/icons/hicolor/512x512/apps/Nextcloud.png",
        extracted_root / "usr/share/pixmaps/Nextcloud.png",
    )
    for path in preferred_paths:
        if path.is_file():
            return path

    # 兼容图标文件名大小写或版本变化，但只接受明显属于
    # Nextcloud 的常见栅格图标，避免误选 Qt/QML 的资源图。
    candidates = sorted(
        path
        for path in extracted_root.rglob("*")
        if path.is_file()
        and path.suffix.lower() in {".png", ".ico", ".jpg", ".jpeg", ".webp"}
        and path.stem.casefold() in {
            "nextcloud",
            "com.nextcloud.desktopclient.nextcloud",
        }
    )
    if candidates:
        return candidates[0]
    raise FileNotFoundError(
        "在 Nextcloud.AppImage 中没有找到 Nextcloud 图标。"
    )


def extract_appimage_icon() -> bytes:
    """
    使用 AppImage runtime 的 --appimage-extract 解包，读取其中的图标。
    解包目录位于临时目录中，函数结束后自动删除。
    """
    section("3. 从 Nextcloud.AppImage 提取图标")
    with tempfile.TemporaryDirectory(prefix="nextcloud-appimage-") as temp_dir:
        result = subprocess.run(
            [
                str(APPIMAGE),
                "--appimage-extract",
            ],
            cwd=temp_dir,
            text=True,
            capture_output=True,
            timeout=120,
        )
        if result.stdout:
            print(result.stdout, end="")
        if result.returncode != 0:
            details = (result.stderr or result.stdout or "没有更多错误信息").strip()
            raise RuntimeError(
                f"解包 Nextcloud.AppImage 失败（返回码 {result.returncode}）：{details}"
            )
        extracted_root = Path(temp_dir) / "squashfs-root"
        if not extracted_root.is_dir():
            raise RuntimeError(
                "AppImage 解包完成，但没有找到 squashfs-root 目录。"
            )
        icon_path = find_extracted_icon(extracted_root)
        icon_bytes = icon_path.read_bytes()
        if not icon_bytes:
            raise RuntimeError(f"提取出的图标为空：{icon_path}")

        # 在临时目录被清理前验证图像确实是 Pillow 可处理的栅格图标。
        with Image.open(BytesIO(icon_bytes)) as image:
            image.verify()
            print(
                f"已提取图标：{icon_path.relative_to(extracted_root)} "
                f"({image.width}x{image.height}, {image.format})"
            )
        return icon_bytes


# ============================================================
# 4. Pillow 生成多尺寸 PNG
# ============================================================
def remove_old_icons() -> None:
    """
    删除我们以前安装的 nextcloud-appimage 图标。
    特别删除之前安装过的 scalable SVG，避免 Cinnamon/GTK
    优先选到有问题的 SVG，而不是新生成的 PNG。
    """
    if not ICON_BASE.exists():
        return
    removed = []
    for path in ICON_BASE.rglob(f"{ICON_NAME}.*"):
        if not path.is_file():
            continue
        try:
            path.unlink()
            removed.append(path)
        except OSError as exc:
            print(
                f"警告：无法删除旧图标 {path}: {exc}",
                file=sys.stderr,
            )
    if removed:
        print("已清理旧版本图标：")
        for path in removed:
            print(f"  {path}")


def install_icons(png_bytes: bytes) -> None:
    section("4. 安装 hicolor PNG 图标")
    remove_old_icons()
    with Image.open(BytesIO(png_bytes)) as source_image:
        source = source_image.convert("RGBA")
        print(f"内存源图：{source.width}x{source.height}")
        for size in ICON_SIZES:
            output_dir = ICON_BASE / f"{size}x{size}" / "apps"
            output_dir.mkdir(
                parents=True,
                exist_ok=True,
            )
            output_file = output_dir / f"{ICON_NAME}.png"
            if source.size == (size, size):
                resized = source.copy()
            else:
                resized = source.resize(
                    (size, size),
                    Image.Resampling.LANCZOS,
                )
            resized.save(
                output_file,
                format="PNG",
                optimize=True,
            )
            print(f"{size:>3}x{size:<3} -> {output_file}")


# ============================================================
# 5. 创建 .desktop
# ============================================================
def create_desktop_file(version: str) -> None:
    section("5. 创建 Desktop Entry")
    DESKTOP_DIR.mkdir(
        parents=True,
        exist_ok=True,
    )
    if version == "unknown":
        comment_en = "Nextcloud desktop client"
        comment_zh = "Nextcloud 桌面客户端"
        version_line = ""
    else:
        comment_en = f"Nextcloud desktop client {version}"
        comment_zh = f"Nextcloud 桌面客户端 {version}"
        version_line = f"X-AppImage-Version={version}\n"
    content = f"""[Desktop Entry]
Version=1.0
Type=Application
Name=Nextcloud
Name[zh_CN]=Nextcloud
GenericName=Desktop Sync Client
GenericName[zh_CN]=桌面同步客户端
Comment={comment_en}
Comment[zh_CN]={comment_zh}
Exec={APPIMAGE}
TryExec={APPIMAGE}
Icon={ICON_NAME}
Terminal=false
Categories=Network;FileTransfer;
StartupNotify=true
PrefersNonDefaultGPU=false
{version_line}"""
    DESKTOP_FILE.write_text(
        content,
        encoding="utf-8",
    )
    DESKTOP_FILE.chmod(0o644)
    print(f"创建完成：{DESKTOP_FILE}")
    print()
    print(content.rstrip())


# ============================================================
# 6. 验证 .desktop
# ============================================================
def validate_desktop_file() -> None:
    section("6. 验证 Desktop Entry")
    validator = shutil.which("desktop-file-validate")
    if validator is None:
        print("没有安装 desktop-file-validate，跳过验证。")
        return
    result = subprocess.run(
        [
            validator,
            str(DESKTOP_FILE),
        ],
        text=True,
        capture_output=True,
    )
    if result.stdout:
        print(result.stdout, end="")
    if result.stderr:
        print(
            result.stderr,
            end="",
            file=sys.stderr,
        )
    if result.returncode != 0:
        raise RuntimeError("desktop-file-validate 验证失败。")
    print("Desktop Entry 验证通过。")


# ============================================================
# 7. 刷新 GTK / Cinnamon
# ============================================================
def refresh_desktop_environment() -> None:
    section("7. 刷新 GTK / Cinnamon 桌面资源")
    ICON_BASE.mkdir(
        parents=True,
        exist_ok=True,
    )
    # 更新图标主题根目录 mtime。
    os.utime(
        ICON_BASE,
        None,
    )
    print(f"已更新图标主题目录时间：{ICON_BASE}")
    # --------------------------------------------------------
    # GTK 图标缓存
    #
    # Linux Mint 用户级 ~/.local/share/icons/hicolor
    # 有时会出现：
    #
    #   The generated cache was invalid.
    #
    # 所以这里作为 best-effort，不让其影响整个安装。
    # --------------------------------------------------------
    gtk_cache = shutil.which("gtk-update-icon-cache")
    if gtk_cache:
        print()
        print("尝试刷新 GTK 图标缓存（失败不会中止安装）：")
        result = subprocess.run(
            [
                gtk_cache,
                "-f",
                "-t",
                str(ICON_BASE),
            ],
            text=True,
            capture_output=True,
        )
        if result.stdout:
            print(result.stdout, end="")
        if result.stderr:
            print(
                result.stderr,
                end="",
                file=sys.stderr,
            )
        if result.returncode == 0:
            print("GTK 图标缓存刷新完成。")
        else:
            print(f"警告：gtk-update-icon-cache 返回 {result.returncode}。")
            print("这不会影响安装，GTK/Cinnamon 仍可直接查找 hicolor 图标。")
            # 清理由失败缓存生成留下的临时文件。
            invalid_cache = ICON_BASE / ".icon-theme.cache"
            if invalid_cache.exists():
                try:
                    invalid_cache.unlink()
                    print(f"已删除无效临时缓存：{invalid_cache}")
                except OSError:
                    pass
    else:
        print("没有找到 gtk-update-icon-cache，跳过。")
    # --------------------------------------------------------
    # Desktop Application Database
    # --------------------------------------------------------
    updater = shutil.which("update-desktop-database")
    if updater:
        print()
        print("刷新 Desktop Database：")
        result = subprocess.run(
            [
                updater,
                str(DESKTOP_DIR),
            ],
            text=True,
            capture_output=True,
        )
        if result.stdout:
            print(result.stdout, end="")
        if result.stderr:
            print(
                result.stderr,
                end="",
                file=sys.stderr,
            )
        if result.returncode == 0:
            print("Desktop Database 刷新完成。")
        else:
            print(
                f"警告：update-desktop-database 返回 {result.returncode}",
                file=sys.stderr,
            )
    else:
        print("没有找到 update-desktop-database，跳过。")


# ============================================================
# 8. 最终检查
# ============================================================
def final_check(version: str) -> None:
    section("安装完成")
    print("AppImage：")
    print(f"  {APPIMAGE}")
    print()
    print("Nextcloud 版本：")
    print(f"  {version}")
    print()
    print("Desktop Entry：")
    print(f"  {DESKTOP_FILE}")
    print()
    print("Desktop ID：")
    print("  nextcloud-appimage")
    print()
    print("Icon：")
    print(f"  {ICON_NAME}")
    print()
    print("已安装图标：")
    all_ok = True
    for size in ICON_SIZES:
        icon = ICON_BASE / f"{size}x{size}" / "apps" / f"{ICON_NAME}.png"
        if icon.is_file():
            status = "OK"
        else:
            status = "MISSING"
            all_ok = False
        print(f"  [{status:<7}] {size:>3}x{size:<3} {icon}")
    print()
    print("AppImage 临时解包目录：已清理")
    print("中间 256x256 PNG：不保存")
    print()
    print("测试启动：")
    print()
    print("  gtk-launch nextcloud-appimage")
    print()
    print("再次验证 Desktop Entry：")
    print()
    print(
        "  desktop-file-validate ~/.local/share/applications/nextcloud-appimage.desktop"
    )
    if not all_ok:
        raise RuntimeError("部分图标文件安装失败。")


# ============================================================
# main
# ============================================================
def main() -> None:
    print("Nextcloud AppImage 一键安装及桌面集成工具")
    try:
        install_appimage()
        version = detect_nextcloud_version()
        png_bytes = extract_appimage_icon()
        install_icons(png_bytes)
        # 明确释放提取出的图标数据。
        del png_bytes
        create_desktop_file(version)
        validate_desktop_file()
        refresh_desktop_environment()
        final_check(version)
    except KeyboardInterrupt:
        print(
            "\n用户取消。",
            file=sys.stderr,
        )
        sys.exit(130)
    except Exception as exc:
        print()
        print(
            f"安装失败：{exc}",
            file=sys.stderr,
        )
        sys.exit(1)


if __name__ == "__main__":
    main()
