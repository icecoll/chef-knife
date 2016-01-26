group node['group']

user node['user']['name'] do
  gid node['group']
  home "/home/#{node['user']['name']}"
  password node['user']['password']
  shell "/bin/bash"
  supports manage_home: true
end

bash 'give group sudo privileges' do
  code <<-EOH
    sed -i '/%#{node['group']}.*/d' /etc/sudoers
    echo '%#{node['group']} ALL=(ALL) ALL' >> /etc/sudoers
  EOH
  not_if "grep -xq '%#{node['group']} ALL=(ALL) ALL' /etc/sudoers"
end

directory "/home/#{node['user']['name']}/.ssh" do
  owner node['user']['name']
end

# add ssh keys, as deployment key on bitbucket
template "/home/#{node['user']['name']}/.ssh/id_rsa.pub" do
  source "id_rsa.pub"
  owner node['user']['name']
  mode 0600
end

template "/home/#{node['user']['name']}/.ssh/id_rsa" do
  source "id_rsa"
  owner node['user']['name']
  mode 0600
end
