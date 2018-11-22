# -*- mode: ruby -*-
# vi: set ft=ruby :


VAGRANTFILE_API_VERSION = "2"

cluster = {
  "openstack01" => { :ip1 => "192.168.157.11", :ip2 => "192.168.197.11", :cpus => 2, :mem => 4096, :script => "kolla-install.sh"},
  "openstack02" => { :ip1 => "192.168.157.12", :ip2 => "192.168.197.12", :cpus => 2, :mem => 4096, :script => "deploy.sh"},
  "openstack03" => { :ip1 => "192.168.157.13", :ip2 => "192.168.197.13", :cpus => 2, :mem => 4096, :script => "deploy.sh"}
}


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  cluster.each_with_index do |(hostname, info), index|
  
    config.hostmanager.enabled = true
  
    config.vm.define hostname do |cfg|
      cfg.vm.provider :virtualbox do |vb, override|
        config.vm.box = "ubuntu/xenial64"
        config.vm.synced_folder ".", "/vagrant"
        config.disksize.size = '30GB'
        override.vm.network :private_network, ip: "#{info[:ip1]}"
        override.vm.network :private_network, ip: "#{info[:ip2]}"
        override.vm.hostname = hostname
        vb.name = hostname
        vb.customize ["modifyvm", :id, "--memory", info[:mem], "--cpus", info[:cpus], "--hwvirtex", "on"]
      end # end provider
      cfg.vm.provision :shell, path: info[:script], keep_color: "true"
    end # end config
  end # end cluster
end