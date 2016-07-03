# template "/etc/logrotate.d/sinatra_logrotate.conf" do
#   source "sinatra_logrotate.conf"
#   # owner node['user']['name']
#   # mode 0600
# end
bash 'add sinatra log file' do
  cwd '/var/log'
  code <<-EOH
    touch /var/log/unicorn.stderr.log 
    touch /var/log/unicorn.stdout.log 
    chown robot:deploy /var/log/unicorn.*
  EOH
  not_if { ::File.exists?('/var/log/unicorn.stderr.log') && ::File.exists?('/var/log/unicorn.stdout.log')}
end
