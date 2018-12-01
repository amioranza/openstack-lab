# Deploy an Openstack lab with ease

## Pre-reqs
- A modern computer (I've tried on Core i7 7th generation) with more than 10gb RAM, the VM used to run Openstack AIO uses 10gb RAM, you can change this setting on Vagrantfile, but performance issues can happen.
- Vagrant - https://www.vagrantup.com/
- VirtualBox - https://www.virtualbox.org/

## Vagrant plugins

1. vagrant-hostmanager
2. vagrant-disksize

To install Vagrant plugins run commands below:

```
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-disksize
```

## Instructions

1. Clone this repo `git clone https://github.com/amioranza/openstack-lab.git`
2. Enter openstack-lab directory
3. Run `vagrant up` to create the VM's
4. After VM creation run `vagrant ssh openstack01` to login to the new VM
5. Inside the VM openstack01 run the following command to spin up the Openstack with kolla-ansible:
```
/vagrant/kolla-install.sh
```
6. Get the admin credentials `cat /etc/kolla/admin-openrc.sh | grep OS_PASS | cut -f2 -d=`
7. Login to http://192.168.157.100 with admin credentials to check if everything is fine.
8. Create a demo project (optional):
```
. /etc/kolla/admin-openrc.sh
 /usr/share/kolla-ansible/init-runonce
 ```

9. Be happy openstacking.
