terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.31.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.1"
    }
    vultr = {
      source  = "vultr/vultr"
      version = ">= 2.11.4"
    }
  }
}

resource "tls_private_key" "ssh_key" {
  algorithm = "ED25519"
}

resource "vultr_firewall_group" "server" {}

resource "vultr_instance" "server" {
  region            = var.vultr_server_region
  plan              = var.vultr_server_plan
  os_id             = 1743
  label             = var.name
  hostname          = var.name
  firewall_group_id = vultr_firewall_group.server.id
  enable_ipv6       = true

  connection {
    type     = "ssh"
    user     = "root"
    password = vultr_instance.server.default_password
    host     = vultr_instance.server.main_ip
  }

  provisioner "remote-exec" {
    inline = [
      "#!/bin/bash",

      "set -euo pipefail",
      "export DEBIAN_FRONTEND=noninteractive",

      "apt-get -yq update",
      "apt-get -yq upgrade",

      # Install Docker
      "apt-get -yq install ca-certificates curl gnupg lsb-release",
      "mkdir -p /etc/apt/keyrings",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "apt-get -yq update",
      "apt-get -yq install docker-ce docker-ce-cli containerd.io docker-compose-plugin",

      # Create User
      "adduser --disabled-password --gecos \"\" ${var.username}",
      "usermod -aG docker ${var.username}",
      "su - ${var.username} -c \"mkdir ~/.ssh ~/${var.username}\"",
      "su - ${var.username} -c \"echo \\\"${tls_private_key.ssh_key.public_key_openssh}\\\" >> ~/.ssh/authorized_keys\"",
    ]
  }
}

resource "google_dns_record_set" "domain_ipv4" {
  name         = "${var.domain_name}."
  managed_zone = var.dns_managed_zone
  type         = "A"
  ttl          = 60

  rrdatas = [vultr_instance.server.main_ip]
}

resource "google_dns_record_set" "domain_ipv6" {
  name         = "${var.domain_name}."
  managed_zone = var.dns_managed_zone
  type         = "AAAA"
  ttl          = 60

  rrdatas = [vultr_instance.server.v6_main_ip]
}

resource "vultr_reverse_ipv4" "domain_reverse_ipv4" {
  instance_id = vultr_instance.server.id
  ip          = vultr_instance.server.main_ip
  reverse     = var.domain_name
}

resource "vultr_reverse_ipv6" "domain_reverse_ipv6" {
  instance_id = vultr_instance.server.id
  ip          = vultr_instance.server.v6_main_ip
  reverse     = var.domain_name
}
