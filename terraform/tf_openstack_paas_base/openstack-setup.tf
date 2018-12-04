provider "openstack" {
  auth_url = "http://openstack.mdcnet.int:5000/v3"
  insecure = true
}

resource "openstack_networking_router_v2" "services-rt" {
  name                = "services-router"
  admin_state_up      = true
  external_network_id = "b65fcbea-ca54-4062-81ba-c9806cca3df1"
}

# SERVICES NETWORK
resource "openstack_networking_network_v2" "services-net" {
  name           = "services-net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "services-net-subnet" {
  name            = "services-net-subnet"
  network_id      = "${openstack_networking_network_v2.services-net.id}"
  cidr            = "${var.services_net}"
  ip_version      = 4
  dns_nameservers = ["${var.dns_servers}"]
}

resource "openstack_networking_router_interface_v2" "services-rt_interface_1" {
  router_id = "${openstack_networking_router_v2.services-rt.id}"
  subnet_id = "${openstack_networking_subnet_v2.services-net-subnet.id}"
}

# FRONTEND NETWORK
resource "openstack_networking_network_v2" "frontend-net" {
  name           = "frontend-net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "frontend-net-subnet" {
  name            = "services-net-subnet"
  network_id      = "${openstack_networking_network_v2.frontend-net.id}"
  cidr            = "${var.frontend_net}"
  ip_version      = 4
  dns_nameservers = ["${var.dns_servers}"]
}

resource "openstack_networking_router_interface_v2" "services-rt_interface_2" {
  router_id = "${openstack_networking_router_v2.services-rt.id}"
  subnet_id = "${openstack_networking_subnet_v2.frontend-net-subnet.id}"
}

# ALPHA NETWORK
resource "openstack_networking_network_v2" "alpha-net" {
  name           = "alpha-net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "alpha-net-subnet" {
  name            = "alpha-net-subnet"
  network_id      = "${openstack_networking_network_v2.alpha-net.id}"
  cidr            = "${var.alpha_net}"
  ip_version      = 4
  dns_nameservers = ["${var.dns_servers}"]
}

resource "openstack_networking_router_interface_v2" "services-rt_interface_3" {
  router_id = "${openstack_networking_router_v2.services-rt.id}"
  subnet_id = "${openstack_networking_subnet_v2.alpha-net-subnet.id}"
}

# HOMOLOG NETWORK
resource "openstack_networking_network_v2" "homolog-net" {
  name           = "homolog-net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "homolog-net-subnet" {
  name            = "homolog-net-subnet"
  network_id      = "${openstack_networking_network_v2.homolog-net.id}"
  cidr            = "${var.homolog_net}"
  ip_version      = 4
  dns_nameservers = ["${var.dns_servers}"]
}

resource "openstack_networking_router_interface_v2" "services-rt_interface_4" {
  router_id = "${openstack_networking_router_v2.services-rt.id}"
  subnet_id = "${openstack_networking_subnet_v2.homolog-net-subnet.id}"
}

resource "openstack_networking_secgroup_v2" "services-sg" {
  name        = "services-sg"
  description = "Security group for services"
}

resource "openstack_networking_secgroup_rule_v2" "http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.services-sg.id}"
}

resource "openstack_networking_secgroup_rule_v2" "https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.services-sg.id}"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.services-sg.id}"
}

resource "openstack_networking_secgroup_rule_v2" "ping" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.services-sg.id}"
}

resource "openstack_networking_secgroup_rule_v2" "grafana" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3000
  port_range_max    = 3000
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.services-sg.id}"
}

resource "openstack_networking_secgroup_rule_v2" "prometheus" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9090
  port_range_max    = 9090
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.services-sg.id}"
}

resource "openstack_networking_secgroup_rule_v2" "node-expoter" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9100
  port_range_max    = 9100
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.services-sg.id}"
}

resource "openstack_networking_secgroup_rule_v2" "prometheus1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10254
  port_range_max    = 10254
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.services-sg.id}"
}

resource "openstack_networking_secgroup_rule_v2" "graylog-api" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9000
  port_range_max    = 9000
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.services-sg.id}"
}

resource "openstack_networking_secgroup_rule_v2" "graylog-ui" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9001
  port_range_max    = 9001
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.services-sg.id}"
}
resource "openstack_networking_secgroup_rule_v2" "graylog-tcp-input" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5140
  port_range_max    = 5140
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.services-sg.id}"
}
resource "openstack_networking_secgroup_rule_v2" "graylog-udp-input" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 5140
  port_range_max    = 5140
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.services-sg.id}"
}
resource "openstack_networking_secgroup_rule_v2" "opmon" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5666
  port_range_max    = 5666
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.services-sg.id}"
}
