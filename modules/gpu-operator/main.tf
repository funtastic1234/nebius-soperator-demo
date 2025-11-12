# Stub module - not used when use_preinstalled_gpu_drivers = true
# This is a placeholder to allow terraform init to succeed

variable "cluster_id" {}
variable "parent_id" {}
variable "enable_dcgm_exporter" {}
variable "enable_dcgm_service_monitor" {}
variable "relabel_dcgm_exporter" {}

output "stub" {
  value = "stub"
}
