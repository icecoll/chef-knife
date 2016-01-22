git '/root/ss' do
  repository 'https://github.com/shadowsocks/shadowsocks-libev.git'
  reference 'master'
  action :sync
end

bash 'install ss' do
  cwd '/root/ss'
  code <<-EOH
    touch done
    ./configure && make && make install
  EOH
  not_if { ::File.exists? '/root/ss/done' }
end
