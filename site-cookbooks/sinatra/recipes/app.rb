## create www directory
directory "/var/www" do
  user node['user']['name']
  group node['group']
  mode 0755
end

git '/home/robot/socket_server' do
  repository 'git@bitbucket.org:everants/freeway_socket.git'
  reference 'master'
  action :sync
  user node['user']['name']
  group node['group']
end

bash 'start the socket_server & nohup ' do
   cwd '/home/robot/socket_server'
   user node['user']['name']
   group node['group']
   code <<-EOH
     bundle install
     touch done
     nohup ruby server.rb &
     EOH
  not_if { ::File.exists? '/home/robot/socket_server/done' }
end
#
## create shared directory structure for app
#path = "/var/www/#{node['app']}/shared/config"
#execute "mkdir -p #{path}" do
#  user node['user']['name']
#  group node['group']
#  creates path
#end
#
# create database.yml file
#template "#{path}/database.yml" do
#  source "database.yml.erb"
#  mode 0640
#  owner node['user']['name']
#  group node['group']
#end

# set unicorn config
#template "/etc/init.d/unicorn_#{node['app']}" do
#  source "unicorn.sh.erb"
#  mode 0755
#  owner node['user']['name']
#  group node['group']
#end
#
## add init script link
#execute "update-rc.d unicorn_#{node['app']} defaults" do
#  not_if "ls /etc/rc2.d | grep unicorn_#{node['app']}"
#end
