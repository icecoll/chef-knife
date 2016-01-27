execute "yum -y install epel-release"
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
      yum install -y sysstat mosh wget telnet nc patch make git openssl-devel readline-devel zlib-devel mailx man dstat iotop iptraf hdparm  socat
    EOC
    # not_if "yum grouplist installed | grep 'Development Libraries'"
  end

  bash "create swap file" do
    user "root"
    # setenforce 0: nginx will  Permission denied error with unicorn socks unless set this to 0
    code <<-EOC
      setenforce 0
      mkdir -p /var/cache/swap/
      dd if=/dev/zero of=/var/cache/swap/swap0 bs=1M count=512
      chmod 0600 /var/cache/swap/swap0
      mkswap /var/cache/swap/swap0 
      swapon /var/cache/swap/swap0
    EOC
    not_if { File.exists? "/var/cache/swap/swap0" }
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
