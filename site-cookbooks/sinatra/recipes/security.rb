package 'fail2ban'

service 'fail2ban' do
  action [:enable, :start]
end

template "/etc/logrotate.d/sinatra_logrotate.conf" do
  source "sinatra_logrotate.conf"
  # owner node['user']['name']
  # mode 0600
end

execute "logrotate --force /etc/logrotate.d/sinatra_logrotate.conf"
