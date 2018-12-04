resource "openstack_compute_instance_v2" "registry" {
  name              = "${var.hostname_prefix}${format("%d", count.index+1)}"
  image_name        = "${var.openstack_image_name}"
  flavor_name       = "${var.openstack_flavor_name}"
  availability_zone = "${var.openstack_az}"
  key_pair          = "${var.openstack_kp}"
  security_groups   = ["${data.openstack_networking_secgroup_v2.services-sg.name}"]

  network {
    name = "${data.openstack_networking_network_v2.services-net.name}"
  }

  user_data = "#cloud-config\nhostname: ${var.hostname_prefix}${format("%d", count.index+1)}.${var.default_domain}\nfqdn: ${var.hostname_prefix}${format("%d", count.index+1)}.${var.default_domain}"

  #provisioner "chef" {
  #  environment             = "${var.chef_env}"
  #  node_name               = "${var.hostname_prefix}${format("%d", count.index+1)}.${var.default_domain}"
  #  server_url              = "${var.chef_server_url}"
  #  user_name               = "${var.chef_user}"
  #  run_list                = ["${var.chef_run_list}"]
  #  user_key                = "${file("~/.chef/${var.chef_user}.pem")}"
  #  recreate_client         = true
  #  ssl_verify_mode         = "verify_none"
  #  fetch_chef_certificates = true
  #  version                 = "${var.chef_client_version}"
#
  #  connection {
  #    type        = "ssh"
  #    user        = "${var.chef_ssh_user}"
  #    private_key = "${file("${var.chef_ssh_keyfile}")}"
  #  }
  #}

  count = "${var.node_count}"
}
