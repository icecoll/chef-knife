#!/usr/bin/ruby
staging_servers = [ "103.41.132.27","160.16.243.157"]

# 181 runs on apache, spescial care needed
production_servers = [ 
  "202.168.153.23", "202.168.153.30",
  "106.187.93.181",
  "106.185.38.154", "106.187.55.4", 
  "106.187.92.31", "106.187.100.102", "160.16.239.195", 
  "104.131.151.145", "107.170.249.223", "45.55.29.175", 
  "159.203.195.6", "107.170.194.61", "162.243.158.181",
  "45.120.158.121", "45.120.158.67", "45.124.67.113"]

servers = production_servers


servers.each do |server|
  log_file = "/tmp/chef-#{server}.log"
  pid = spawn("knife solo cook root@#{server} nodes/104.131.151.145.json  --override-runlist 'recipe[sinatra::single_task]'", out: log_file, err: log_file)
  Process.detach(pid)
end

puts "use `tail /tmp/chef-*.log |less` to see progress"


