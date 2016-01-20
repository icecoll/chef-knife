# create .bash_profile file
cookbook_file "/home/#{node['user']['name']}/.bash_profile" do
  source "bash_profile"
  mode 0644
  owner node['user']['name']
  group node['group']
end

# install rbenv
bash 'install rbenv' do
  user node['user']['name']
  cwd "/home/#{node['user']['name']}"
  code <<-EOH
    export HOME=/home/#{node['user']['name']}
    curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
  EOH
  not_if { File.exists?("/home/#{node['user']['name']}/.rbenv/bin/rbenv") }
end

#execute "install ruby" do
#  user node['user']['name']
#  cwd "/home/#{node['user']['name']}"
#  command "source /home/#{node['user']['name']}/.bash_profile"
#  command "rbenv install #{node['ruby']['version']}"
#  command "rbenv global #{node['ruby']['version']}"
#  command "echo 'gem: -–no-ri -–no-rdoc' > .gemrc"
#  command "gem install bundler"
#  command "rbenv rehash"
#end
# install ruby
version_path = "/home/#{node['user']['name']}/.rbenv/version"
bash 'install ruby' do
  #user node['user']['name']
  #cwd "/home/#{node['user']['name']}"
  code <<-EOH
    #gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    #curl -sSL https://get.rvm.io | bash -s stable --ruby
    HOME=/home/robot
    export PATH=$PATH:$HOME/.rbenv/bin
    #echo $PATH > mrc
    cd /home/robot
    echo $PATH > mrc3
    su robot
    rbenv install 2.2.2
    rbenv global 2.2.2
    echo 'gem: -–no-ri -–no-rdoc' > .gemrc
    gem install bundler
    rbenv rehash
    exit
  EOH
  not_if { File.exists?(version_path) && `cat #{version_path}`.chomp.split[0] == node['ruby']['version'] }
end
