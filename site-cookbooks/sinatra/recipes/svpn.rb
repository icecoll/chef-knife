git '/root/svpn' do
  repository 'https://github.com/lincank/ShadowVPN.git'
  reference 'master'
  action :sync
end

bash 'upgrade autoconf' do
  cwd '/root'
  code <<-EOH
    wget http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
    tar xvfvz autoconf-2.69.tar.gz
    cd autoconf-2.69
    ./configure && make && make install
  EOH
  not_if { ::File.exists? '/root/autoconf-2.69.tar.gz' }
end

bash 'install svpn' do
  cwd '/root/svpn'
  code <<-EOH
    git submodule update --init
    touch done
    ./autogen.sh
    ./configure --enable-static --sysconfdir=/etc && make && make install
  EOH
  not_if { ::File.exists? '/usr/local/bin/shadowvpn' }
end

bash  "change permission for shadowvpn dir" do
  code <<-EOH
     chown -R #{node['user']['name']}:#{node['group']} /etc/shadowvpn/
     chmod -R 775 /etc/shadowvpn/
  EOH
end

bash 'give group passwordless sudo privileges' do
  code <<-EOH
    sed -i '/Defaults    requiretty/s/^/#/' /etc/sudoers
    sed -i 's/%#{node['group']} ALL=(ALL) ALL/%#{node['group']} ALL=(ALL)       NOPASSWD: ALL/g' /etc/sudoers
  EOH
  not_if "grep -xq '#Defaults    requiretty' /etc/sudoers"
end

