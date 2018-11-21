#/usr/bin/env bash

echo "Update apt packages cache"
sudo apt-get update
echo "Install python-pip"
sudo apt-get -y install python-pip
echo "Update python-pip"
sudo pip install -U pip
echo "Install kolla-ansible pre-reqs"
sudo apt-get -y install python-dev libffi-dev gcc libssl-dev python-selinux python-setuptools
echo "Install ansible"
sudo pip install -U ansible
sudo mkdir -p /etc/ansible
echo "
[defaults]
host_key_checking=False
pipelining=True
forks=100
" | sudo tee /etc/ansible/ansible.cfg

echo "Install kolla-ansible"
sudo pip install kolla-ansible
echo "Install openstack clients"
sudo pip install python-openstackclient python-glanceclient python-neutronclient
echo "Copying files to /etc/kolla"
sudo cp -r /usr/local/share/kolla-ansible/etc_examples/kolla /etc/
echo "Creating the inventory directory"
sudo mkdir -p /etc/kolla/inventory
sudo cp /usr/local/share/kolla-ansible/ansible/inventory/* /etc/kolla/inventory/
#echo "Generating the ssh keys"
#sudo ssh-keygen -q -f ~/.ssh/id_rsa -N ''
#runuser -l  vagrant -c "ssh-keygen -q -f ~/.ssh/id_rsa -N ''"
#sudo cp ~/.ssh/id_rsa.pub /vagrant/authorized_keys
#sudo cat /home/vagrant/.ssh/id_rsa.pub >> /vagrant/authorized_keys
echo "Copying inventory to inventory directory"
sudo cp /vagrant/multinode /etc/kolla/inventory/
echo "Generating kolla passwords"
sudo kolla-genpwd
echo "Copying globals.yml to /etc/kolla"
sudo cp /vagrant/globals.yml /etc/kolla/globals.yml