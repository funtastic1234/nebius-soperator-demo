# Stub module - not used when nfs.enabled = false
# This is a placeholder to allow terraform init to succeed

variable "parent_id" {}
variable "subnet_id" {}
variable "platform" {}
variable "preset" {}
variable "instance_name" {}
variable "nfs_disk_name_suffix" {}
variable "nfs_ip_range" {}
variable "nfs_size" {}
variable "nfs_path" {}
variable "ssh_user_name" {}
variable "ssh_public_keys" {}
variable "public_ip" {}

output "nfs_export_path" {
  value = "/stub"
}

output "nfs_server_internal_ip" {
  value = "127.0.0.1"
}
