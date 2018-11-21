# Deploy an Openstack lab with ease

## Pre-reqs
- Vagrant - https://www.vagrantup.com/
- VirtualBox - https://www.virtualbox.org/

## Instructions

1. Clone this repo
2. Run `vagrant up` to create the VM's
3. After VM creation run `vagrant ssh openstack01` to login to the new VM
4. Inside the VM openstack01 run the following commands to spin up the Openstack with kolla-ansible:
  - `kolla-ansible -i /etc/kolla/inventory/multinode bootstrap-servers`
  - `kolla-ansible -i /etc/kolla/inventory/multinode prechecks`
  - `kolla-ansible -i /etc/kolla/inventory/multinode deploy`
  - `kolla-ansible -i /etc/kolla/inventory/multinode post-deploy`
5. Get the admin credentials `cat /etc/kolla/admin-openrc.sh | grep OS_PASS | cut -f2 -d=`
6. Login to http://192.168.157.10 with admin credentials to check if everything is fine.
7. Create a demo project (optional):
  - `. /etc/kolla/admin-openrc.sh`
  - `/usr/share/kolla-ansible/init-runonce`
