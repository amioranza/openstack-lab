# GENERAL
variable "node_count" {}
variable "hostname_prefix" {}
variable "default_domain" {}
# OPENSTACK
variable "openstack_image_name" {}
variable "openstack_flavor_name" {}
variable "openstack_kp" {}
variable "openstack_az" {
  default = "nova"
}
#CHEF PARAMETERS
variable "chef_client_version" {
  default = "13.6.4"
}
variable "chef_user" {}
variable "chef_server_url" {}
variable "chef_env" {}
variable "chef_ssh_user" {}
variable "chef_run_list" {
  type = "list"
}
variable "chef_ssh_keyfile" {}