# rpmfusion

# RPM Fusion提供了Fedora项目或Red Hat不想发布的软件。
# 该软件作为所有当前 Fedora 版本和当前 Red Hat Enterprise Linux 或克隆版本的预编译RPM提供;
# 您可以将RPMFusion存储库与yum和PackageKit等工具一起使用。

# RPM融合是一个合并的运球，新鲜的rpms，和Livna;
# 我们的目标是通过将尽可能多的附加软件分组到单个位置来简化最终用户体验。
# 另请参阅我们的基本原则。

# RHEL or compatible like CentOS
sudo dnf install --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %rhel).noarch.rpm
sudo dnf install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm
