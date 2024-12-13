provider "google" {
  credentials = file(var.service_account_key_path)
  project     = var.gcp_project_id
  region      = var.region
}

# Provisionner une instance VM
resource "google_compute_instance" "vm_instance" {
  name         = var.machine_name
  machine_type = "custom-${var.machine_cpu_count}-${var.machine_memory_mb}"
  zone         = var.machine_zone

  boot_disk {
    initialize_params {
      image = var.machine_image
      size  = var.machine_storage_size
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  tags = ["http-server", "https-server"]

  metadata = {

    # Desactiver OS Login pour la gestion d'identité via GCP
    "enable-oslogin" = "FALSE"  

    # Clé SSH publique pour l'accès via clé SSH
    "ssh-keys" = "kone_wolouho:${var.ssh_public_key}"

    # Script de démarrage pour définir le mot de passe et activer root login
    "startup-script" = <<-EOT
      #!/bin/bash
      echo "kone_wolouho:${var.default_user_password}" | chpasswd
      sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
      systemctl restart sshd
    EOT

    }

}


# Ajouter une entrée DNS dans la zone Cloud DNS
resource "google_dns_record_set" "vm_dns_record" {
  name         = "${var.dns_name}."
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip]

  managed_zone = var.managed_zone
}


# Wait for the host to be reachable
resource "null_resource" "wait_for_ssh" {
  depends_on = [google_compute_instance.vm_instance]

  provisioner "local-exec" {
    command = <<EOT
      while ! nc -zv ${google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip} 22; do
        echo "Waiting for SSH..."
        sleep 5
      done
    EOT
  }
}


resource "null_resource" "add_known_host" {
  depends_on = [null_resource.wait_for_ssh]

  provisioner "local-exec" {
    command = <<EOT
      ssh-keyscan -H ${google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip} >> ~/.ssh/known_hosts
    EOT
  }
}


resource "null_resource" "ansible_config" {
  depends_on = [null_resource.add_known_host]

  provisioner "local-exec" {
    command = "ansible-playbook -i '${google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip},' -u ${var.default_user} --private-key=${var.ssh_private_key} -e 'host_dns=${var.dns_name}' ${var.ansible_playbook_file}" 
  }
}



resource "null_resource" "delete_known_host" {
  depends_on = [null_resource.ansible_config]

  provisioner "local-exec" {
    command = "ssh-keygen -f '/home/albarry/.ssh/known_hosts' -R 'mon.kone-wolouho-oumar.com'"
    }
}