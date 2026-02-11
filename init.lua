-- Leader 键为空格
vim.g.mapleader = " "

-- 显示行号与相对行号
vim.opt.number = true

-- Tab 转为空格，每级缩进 4 个空格
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- 启用真彩色支持
vim.opt.termguicolors = true

-- 搜索结果高亮显示
vim.opt.hlsearch = true

-- 搜索忽略大小写，但输入大写时自动区分
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 输入搜索时实时跳转到第一个匹配
vim.opt.incsearch = true

-- 显示光标所在行
vim.opt.cursorline = true

-- 禁止自动折行
vim.opt.wrap = false

-- 括号匹配时高亮显示对应括号
vim.opt.showmatch = true

-- 高亮匹配括号时间 (单位 0.1 秒)
vim.opt.matchtime = 2

-- 命令行补全时显示候选菜单
vim.opt.wildmenu = true

-- 高亮行尾空白
vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg="#ff0000" })
vim.fn.matchadd("TrailingWhitespace", "\\s\\+$")

-- 快捷保存 / 退出
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "保存文件" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "退出" })

-- 自动安装 lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- 最新稳定版本
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 配置插件
require("lazy").setup({
  -- Gruvbox 配色主题
  { "ellisonleao/gruvbox.nvim" },
  -- 底部状态栏
  { "nvim-lualine/lualine.nvim" },
  -- 文件树
  { "nvim-tree/nvim-tree.lua" },
  -- 语法高亮
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        -- 现在使用主模块 'nvim-treesitter' 进行配置
        require("nvim-treesitter").setup({
            -- 【核心功能配置】
            highlight = {
                enable = true, -- 启用代码高亮
                additional_vim_regex_highlighting = false, -- 避免与传统Vim正则高亮冲突，性能更好
            },
            indent = { enable = true }, -- 启用基于Tree-sitter的缩进（实验性）
            -- 【自动管理语法解析器（推荐）】
            -- 首次启动时自动安装下列语言的解析器
            ensure_installed = { "c", "cpp", "cmake", "lua", "vim", "vimdoc", "bash", "yaml", "xml", "csv", "markdown", "toml", "python", "html", "css", "javascript", "sql" },
            -- 设置为 true 会在启动时同步安装，阻塞直到完成
            sync_install = false,
            -- 设置为 true 会在打开新文件时，自动安装该语言对应的解析器
            auto_install = true,
        })
    end,
  },
  -- Git 状态提示
  { "lewis6991/gitsigns.nvim" },
  -- 显示缩进线
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },
  -- 快速注释/取消注释
  { "numToStr/Comment.nvim" },
  -- 浮动终端
  { "voldikss/vim-floaterm" },
  -- 更漂亮的消息通知
  { "rcarriga/nvim-notify" },
  -- 自动补全框架
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },  -- LSP 源
  { "hrsh7th/vim-vsnip" },     -- snippet 支持
  -- LSP 客户端配置
  { "neovim/nvim-lspconfig" },
  -- Mason 自动管理 LSP
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  -- Ruff 通过 null-ls
  { "jose-elias-alvarez/null-ls.nvim" },
  -- 调试
  { "mfussenegger/nvim-dap" },
})

-- 设置主题
vim.opt.background = "dark"           -- Neovim 主题风格 dark / light
vim.g.gruvbox_contrast_dark = "hard"  -- Gruvbox 主题选项 soft / medium / hard
pcall(vim.cmd, "colorscheme gruvbox")

-- 初始化状态栏
require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = 'gruvbox',
    component_separators = '|',  -- section 内部分隔符
    section_separators = { '', '' },  -- 左右 section 分隔符为空
  }
})

-- 禁用 netrw
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

-- 设置 nvim-tree 选项
require('nvim-tree').setup({
    -- 控制窗口大小和位置
    view = {
        -- 文件树窗口宽度，单位是列（字符数）
        width = 30,
        -- 文件树显示在左侧
        side = 'left',
        -- 调整窗口大小时保持原来窗口比例，防止被自动拉伸
        preserve_window_proportions = true,
    },
    -- 关闭图标显示
    renderer = {
        icons = {
            show = {
                git = false,  -- 禁用 Git 图标
                folder = false,  -- 禁用文件夹图标
                file = false,  -- 禁用文件图标
                folder_arrow = false,  -- 禁用折叠/展开箭头
            }
        }
    },
    -- 高亮当前文件
    update_focused_file = {
        enable = true,
        update_cwd = true,
    },
    -- 禁用 Git 状态显示
    git = {
        enable = true,
    },
})

-- 快捷键绑定 Ctrl+B 打开/关闭文件树
vim.keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>', {
    noremap = true,
    silent = true
})

-- 行号左侧显示 Git 修改标记
require("gitsigns").setup()

-- 显示缩进线
-- require("ibl").setup()

-- 快速注释/取消注释
-- gcc 普通模式 注释/取消当前行
-- gbc 普通模式 块注释/取消块注释（多行）
require('Comment').setup()

-- 更漂亮的消息通知
vim.notify = require("notify")

-- 切换浮动终端
vim.keymap.set("n", "<C-`>", ":FloatermToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("t", "<C-`>", "<C-\\><C-n>:FloatermToggle<CR>", { noremap = true, silent = true })

-- 设置 Python 解释器
-- 自动补全
-- 调试器
-- Ruff格式化
