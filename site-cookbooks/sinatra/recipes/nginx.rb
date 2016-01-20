package "nginx"

# remove default nginx config
default_file = "/etc/nginx/nginx.conf"

execute "rm -f #{default_file}" do
  only_if { File.exists?(default_file) }
end

cookbook_file default_file do
  source "nginx.conf"
  mode 0644
  owner 'root'
  group 'root'
end

# start nginx
service "nginx" do
  supports [:status, :restart]
  action :restart
end

# set custom nginx config
template "/etc/nginx/conf.d/#{node['app']}.conf" do
  source "default/nginx.conf.erb"
  mode 0644
  owner node['user']['name']
  group node['group']
  notifies :restart, "service[nginx]", :delayed
end
