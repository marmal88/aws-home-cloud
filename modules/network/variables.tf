variable "tags" {
  description = "tags for terraform invoked resources"
  type        = map(string)
}

variable "firewall_usr_cidr" {
  description = "Firewall CIDR allow rule for users to access the application"
  type        = list(string)
}

variable "firewall_ssh_cidr" {
  description = "Firewall CIDR allow rule for SSH"
  type        = list(string)
}
