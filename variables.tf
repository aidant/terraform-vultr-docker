variable "dns_name" {
  type        = string
  description = "The domain name to use for the server."
}

variable "dns_managed_zone" {
  type        = string
  description = "The DNS managed zone of the dns_name."
}

variable "username" {
  type        = string
  description = "The username used to access the server."
}

variable "vultr_server_region" {
  type        = string
  description = "The Vultr server region to use."
  default     = "syd"
}

variable "vultr_server_plan" {
  type        = string
  description = "The Vultr server plan to use."
  default     = "vhf-1c-1gb"
}
