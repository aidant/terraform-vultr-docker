output "ssh_key" {
  value       = tls_private_key.ssh_key.private_key_openssh
  description = ""
}

output "vultr_firewall_group_id" {
  value       = vultr_firewall_group.server.id
  description = ""
}
