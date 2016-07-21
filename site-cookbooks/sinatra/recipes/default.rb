execute "yum -y install epel-release"
  bash "yum groupinstall Development tools" do
    user "root"
    group "root"
    code <<-EOC
      yum groupinstall "Development tools" -y
    EOC
    not_if "yum grouplist installed | grep 'Development tools'"
  end

  bash "yum groupinstall Development Libraries" do
    user "root"
    group "root"
    code <<-EOC
      yum groupinstall "Development Libraries" -y
      yum install -y net-tools sysstat mosh wget telnet nc patch make git openssl-devel readline-devel zlib-devel mailx man dstat iotop iptraf hdparm socat iptables-services fail2ban sudo
    EOC
    # not_if "yum grouplist installed | grep 'Development Libraries'"
  end

  bash "create swap file in order to compile ruby" do
    user "root"
    # setenforce 0: nginx will  Permission denied error with unicorn socks unless set this to 0
      # setenforce 0
      # mkdir -p /var/cache/swap/
      # dd if=/dev/zero of=/var/cache/swap/swap0 bs=1M count=512
      # chmod 0600 /var/cache/swap/swap0
      # mkswap /var/cache/swap/swap0 
      # swapon /var/cache/swap/swap0
    code <<-EOC
      SWAP="${1:-512}"
      NEW="$[SWAP*1024]"; TEMP="${NEW//?/ }"; OLD="${TEMP:1}0"
      umount /proc/meminfo 2> /dev/null
      sed "/^Swap\(Total\|Free\):/s,$OLD,$NEW," /proc/meminfo > /etc/fake_meminfo
      mount --bind /etc/fake_meminfo /proc/meminfo
    EOC
    not_if { File.exists? "/etc/fake_meminfo" }
    # not_if { File.exists? "/var/cache/swap/swap0" }
  end

  service "fail2ban" do
    # supports [:status, :restart]
    action [:enable, :start]
  end

  service "firewalld" do
    # supports [:status, :restart]
    action [:disable, :stop]
  end

  # bash 'add iptables rules to block BitTorrent traffic' do
  #   user 'root'
  #   group 'root'
  #   code <<-EOC
  #   iptables -A INPUT -p udp -m multiport --dports 60000:61000 -j ACCEPT
  #   iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j LOGDROP
  #   iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j LOGDROP
  #   iptables -A FORWARD -m string --algo bm --string "peer_id=" -j LOGDROP
  #   iptables -A FORWARD -m string --algo bm --string ".torrent" -j LOGDROP
  #   iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j LOGDROP
  #   iptables -A FORWARD -m string --algo bm --string "torrent" -j LOGDROP
  #   iptables -A FORWARD -m string --algo bm --string "announce" -j LOGDROP
  #   iptables -A FORWARD -m string --algo bm --string "info_hash" -j LOGDROP
  #   service iptables save
  #   touch /root/update_iptables_rules
  #   EOC
  #   not_if { File.exists? "/root/update_iptables_rules" }
  # end

  service "iptables" do
    # supports [:status, :restart]
    action [:disable, :stop]
  end


