include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/${basename(get_terragrunt_dir())}"
}

locals {
  environment_inputs            = read_terragrunt_config(find_in_parent_folders("environment.hcl")).inputs
  environment_firewall_usr_cidr = local.environment_inputs.firewall_usr_cidr
  environment_firewall_ssh_cidr = local.environment_inputs.firewall_ssh_cidr
  environment_tags              = local.environment_inputs.tags
}

inputs = {
  firewall_usr_cidr = local.environment_firewall_usr_cidr
  firewall_ssh_cidr = local.environment_firewall_ssh_cidr
  tags              = local.environment_tags
}
