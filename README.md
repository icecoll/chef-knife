### 使用

	bundle exec knife solo boostrap root@45.32.52.17  nodes/104.131.151.145.json  
	bundle exec knife solo cook root@45.32.52.17  nodes/104.131.151.145.json  

### 批处理多台服务器
多台服务器时，修改`batch_run.rb`里涉及的服务器， 然后

	./batch_run.rb
	
	# 查看各服务器运行的情况
	 tail /tmp/chef-*.log |less
	 
### 使用Vagrant做测试

用prepare命令自动下载安装会很慢，最好是在国外服务器上下载完，再从服务器上获取到vagrant里安装，`Vagrantfile`所在的目录与虚拟机里`/vagrant`目录是共享的。

用以下命令测试：

	# 如果chef已经在虚拟机里装好了，直接cook，不用prepare或bootstrap
	knife solo cook vagrant@127.0.0.1 nodes/104.236.61.106.json -p 2222
	
	# 用--override-runlist指定某些runlist
	knife solo bootstrap vagrant@127.0.0.1 nodes/104.236.61.106.json -p 2222 --override-runlist "recipe[sinatra::svpn]"
