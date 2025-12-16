inputs = {
  prefix = "youghurt-house"
  region = "ap-southeast-1"
  # networking
  availability_zone = ""
  firewall_ssh_cidr = ["151.192.106.218/32"]
  firewall_usr_cidr = ["0.0.0.0/0"]
  # Compute
  instance_type   = "t3.micro"
  ebs_volume_size = 20

  tags = {
    "owner"   = "terraform"
    "project" = "home"
  }
}
