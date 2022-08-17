variable "name" {
  type        = string
  description = "The name to use when creating resources."

  validation {
    condition     = length(var.name) != 0
    error_message = "The \"name\" variable is required and expected to be a string."
  }
}

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
