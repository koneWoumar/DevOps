output "vm_instance_ip" {
  description = "Public IP address of the VM instance"
  value       = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

output "dns_record_name" {
  description = "DNS record name for the instance"
  value       = google_dns_record_set.vm_dns_record.name
}
