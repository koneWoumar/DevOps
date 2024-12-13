module "vm_instance_1" {
  source                  = "../tfmodule/gcp-vm-instance"
  # ---------------gloabl-variable-----------------------#
  service_account_key_path = var.service_account_key_path
  gcp_project_id           = var.gcp_project_id
  region                   = var.region
  machine_zone             = var.machine_zone
  ssh_public_key           = var.ssh_public_key
  managed_zone             = var.managed_zone
  ssh_private_key          = var.ssh_private_key
  machine_image            = var.machine_image
  #----------------path-to-ansible-playbook--------------#

  ansible_playbook_file    = "../ansibleplay/play-system-setup.yml"

  #---------------instance-variables---------------------#

  machine_storage_size     = 20
  machine_name             = "vm-instance-1"
  machine_cpu_count        = "2"
  machine_memory_mb        = "2048"
  default_user_password    = "arrow00932"
  default_user             = "kone_wolouho"
  dns_name                 = "mon.kone-wolouho-oumar.com"

}

