execute "yum -y install epel-release"
#execute "yum -y update"
bash "yum groupinstall Development tools" do
    user "root"
    group "root"
    code <<-EOC
      yum groupinstall "Development tools" -y
    EOC
    not_if "yum grouplist installed | grep 'Development tools'"
  end

  bash "yum groupinstall Development Libraries" do
    user "root"
    group "root"
    code <<-EOC
      yum groupinstall "Development Libraries" -y
    EOC
    not_if "yum grouplist installed | grep 'Development Libraries'"
  end

  %w(
    sysstat
    mosh
    wget
    tmux
    telnet
    nc
    patch
    make
    git
    openssl-devel
    readline-devel
    zlib-devel
    mailx
    man
    dstat
    iotop
    iptraf
    hdparm
    postfix
    postfix-perl-scripts
    socat
  ).each do |pkg|
    package pkg do
      #options "--enablerepo=epel"
      action :install
    end
  end


# install packages
#package "telnet"
#package "postfix"
#package "curl"
#package "git-core"
#package "zlib1g-dev"
#package "libssl-dev"
#package "libreadline-dev"
#package "libyaml-dev"
#package "libsqlite3-dev"
#package "sqlite3"
#package "libxml2-dev"
#package "libxslt1-dev"
#package "libpq-dev"
#package "build-essential"
#package "tree"

# set timezone
#bash "set timezone" do
#  code <<-EOH
#    echo 'US/Pacific-New' > /etc/timezone
#    dpkg-reconfigure -f noninteractive tzdata
#  EOH
#  not_if "date | grep -q 'PDT\|PST'"
#end
