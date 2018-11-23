#/usr/bin/env bash

echo "#####################################################"
echo "#                                                   #"
echo "#                                                   #"
echo "#           Installing pre-requirements             #"
echo "#                                                   #"
echo "#                                                   #"
echo "#####################################################"
echo "Update python-pip"
sudo pip install -U pip
echo "Install kolla-ansible pre-reqs"
sudo apt-get -y install python-dev libffi-dev gcc libssl-dev python-selinux python-setuptools
echo "Install openstack clients"
sudo pip install python-openstackclient python-glanceclient python-neutronclient
echo "Install ansible"
sudo pip install -U ansible
sudo mkdir -p /etc/ansible
echo "
[defaults]
host_key_checking=False
pipelining=True
forks=100
" | sudo tee /etc/ansible/ansible.cfg

echo "#####################################################"
echo "#                                                   #"
echo "#                                                   #"
echo "#      Installing kolla-ansible form git repo       #"
echo "#                                                   #"
echo "#                                                   #"
echo "#####################################################"
sudo git clone -b stable/queens https://github.com/openstack/kolla /opt/kolla
sudo git clone -b stable/queens https://github.com/openstack/kolla-ansible /opt/kolla-ansible
cd /opt
sudo pip install -r kolla/requirements.txt
sudo pip install -r kolla-ansible/requirements.txt
sudo mkdir -p /etc/kolla
sudo cp -r kolla-ansible/etc/kolla/* /etc/kolla
sudo mkdir -p /etc/kolla/config/inventory
sudo cp /vagrant/multinode /etc/kolla/config/inventory/
sudo cp /vagrant/globals.yml /etc/kolla/
echo "#####################################################"
echo "#                                                   #"
echo "#                                                   #"
echo "#          Bootstraping openstack servers           #"
echo "#                                                   #"
echo "#                                                   #"
echo "#####################################################"
cd /opt/kolla-ansible/tools
sudo chown -R vagrant:vagrant /home/vagrant/.ansible
sudo ./generate_passwords.py
sudo ./kolla-ansible -i /etc/kolla/config/inventory/multinode bootstrap-servers
sudo ./kolla-ansible -i /etc/kolla/config/inventory/multinode prechecks
echo "#####################################################"
echo "#                                                   #"
echo "#                                                   #"
echo "#           Deploying openstack servers             #"
echo "#                                                   #"
echo "#                                                   #"
echo "#####################################################"
sudo ./kolla-ansible -i /etc/kolla/config/inventory/multinode deploy
sudo ./kolla-ansible -i /etc/kolla/config/inventory/multinode post-deploy