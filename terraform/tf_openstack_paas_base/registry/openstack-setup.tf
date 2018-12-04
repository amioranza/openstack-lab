provider "openstack" {
  auth_url = "http://openstack.mdcnet.int:5000/v3"
  insecure = true
}

data "openstack_networking_network_v2" "services-net" {
  name = "services-net"
}

data "openstack_networking_secgroup_v2" "services-sg" {
  name = "services-sg"
}
