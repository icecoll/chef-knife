
git '/root/ss' do
  repository 'https://github.com/shadowsocks/shadowsocks-libev.git'
  reference 'master'
  action :sync
end

bash 'install ss' do
  cwd '/root/ss'
  code <<-EOH
    ./configure && make && make install
    touch done
   
  EOH
  not_if { ::File.exists? '/root/ss/done' }
end
