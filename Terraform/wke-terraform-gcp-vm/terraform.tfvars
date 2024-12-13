#-----------------------------Providers------------------------------#
service_account_key_path = "~/.gcp-api-key/wke-devops-gcp-service-account-key.json"
gcp_project_id           = "wkedevops"
region                   = "us-central1"
#-----------------------------Ressources------------------------------#
machine_name             = "wke-gcp-vm-medium"
machine_type             = "e2-medium"
machine_zone             = "us-central1-a"
machine_image            = "debian-12-bookworm-v20241112"
machine_storage_size     = "15"
ssh_public_key           = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8L0QXZt1kJ+iIJmhZQBsiQwZsCohmJ2Ad8wpxjWdkzJxxJXXKm1AisVECtRJzhOOTmZbnADxM1yoLZ68il9hL/mlbVSZUeuJUBjsungHtyS5RL+ygC8Sx+NCDdA0gtoNXnDrCkscyA2YPm9E2DEo8kwH45Gf8+x1rBZ6uvd5m1tw8EzA3HfcnO4hTlbZy1oBy1d/m3WFr7khhGYQ5JUISuYVgZfWvTvE7DqGbHiCY6zgAViD1/rxP7+mm75fcXkIZseHKpBwQ3PNZ8d1HA0nEm6XhEnkhVOnSvxoGA04NJAQuRkOZzjb0k3YvUyIg33H7JR6Tu8wu9+CsHlLWUTirtiCjI6kkOMobwC6QyZWaH1wS56f3hK/3+1iUAfRwrk0c5WdbuDh2GYNRZJ0Sp47aLre1ltiSBKx8U+5/UEwZi97E59xSJsDut79WXcnnHvaPjXfvpJL91FPf7lOtSFUAnlQxsO1ea1YskDz9L7Qlf05qAAO/65KX/gAkXswxatVoKPdKuuHD19d56WtITJaQ6dBZVitcz04ID1fOBo9PPOG7pzlSbsm8cXxSApyteNSPoemb5o2eMepRf1UlBwYyGzmgSxjXWObrwrCHB5NtF7OspQ9RvH7lta3oLCGHgHblkCZg7aQIYWjJiOQR6boMZxnToNj+c+oo7uw1sVzKZQ== kone.wolouho@gmail.com"
ssh_private_key          = "~/.ssh/id_rsa"
default_user_password    = "00932"
default_user             = "kone_wolouho"
#-----------------------------Domaine Network Name------------------------------#
managed_zone             = "wke-zone-cloud-dns"
dns_name                 = "mon.kone-wolouho-oumar.com"
