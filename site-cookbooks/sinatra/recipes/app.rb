## create www directory
directory "/var/www" do
  user node['user']['name']
  group node['group']
  mode 0755
end

bash 'add sinatra log file' do
  cwd '/var/log'
  code <<-EOH
    touch /var/log/unicorn.stderr.log 
    touch /var/log/unicorn.stdout.log 
    chown robot:deploy /var/log/unicorn.*
  EOH
  not_if { ::File.exists?('/var/log/unicorn.stderr.log') && ::File.exists?('/var/log/unicorn.stdout.log')}
end


template "/etc/logrotate.d/sinatra_logrotate.conf" do
  source "sinatra_logrotate.conf"
  # owner node['user']['name']
  # mode 0600
end

bash 'enable hourly logrotate' do
  code <<-EOH
    cp /etc/cron.daily/logrotate /etc/cron.hourly/ 
  EOH
  not_if { ::File.exists?('/etc/cron.hourly/logrotate') }
end
# git '/home/robot/socket_server' do
#   repository 'git@bitbucket.org:everants/freeway_socket.git'
#   reference 'master'
#   action :sync
#   user node['user']['name']
#   group node['group']
# end

# bash 'start the socket_server & nohup ' do
#    cwd '/home/robot/socket_server'
#    user node['user']['name']
#    group node['group']
#    code <<-EOH
#      bundle install
#      sleep 30
#      touch done
#      nohup ruby server.rb &
#      EOH
#   not_if { ::File.exists? '/home/robot/socket_server/done' }
# end
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
