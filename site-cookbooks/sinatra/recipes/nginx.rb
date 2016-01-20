package "nginx"

# remove default nginx config
#default_path = "/etc/nginx/sites-enabled/"
#default_file = "/etc/nginx/sites-enabled/default"
#
#execute "mkdir #{default_path}" do
#  only_if { !Dir.exists?(default_path) }
#end
#
#execute "rm -f #{default_file}" do
#  only_if { File.exists?(default_path) }
#end

# start nginx
service "nginx" do
  supports [:status, :restart]
  action :start
end

# set custom nginx config
template "/etc/nginx/conf.d/#{node['app']}" do
  source "default/nginx.conf.erb"
  mode 0644
  owner node['user']['name']
  group node['group']
  notifies :restart, "service[nginx]", :delayed
end
