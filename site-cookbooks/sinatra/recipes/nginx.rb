package "nginx"

# remove default nginx config
default_file = "/etc/nginx/nginx.conf"



execute "mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak" do
  only_if { File.exists?("/etc/nginx/conf.d/default.conf") }
end

execute "rm -f #{default_file}" do
  only_if { File.exists?(default_file) }
end

execute "mkdir /run" do
  not_if { Dir.exist?("/run") }
end

cookbook_file default_file do
  source "nginx.conf"
  mode 0644
  owner 'root'
  group 'root'
end


# set custom nginx config
template "/etc/nginx/conf.d/#{node['app']}.conf" do
  source "default/nginx.conf.erb"
  mode 0644
  owner node['user']['name']
  group node['group']
  notifies :restart, "service[nginx]", :delayed
end


cookbook_file default_file do
  source "nginx.conf"
  mode 0644
  owner 'root'
  group 'root'
end

# stop apache 
service "httpd" do
  action [:disable, :stop ]
end

# start nginx
service "nginx" do
  supports [:status, :restart]
  action [:enable, :restart ]
end
