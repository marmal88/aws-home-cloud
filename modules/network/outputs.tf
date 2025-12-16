output "security_group" {
  value = aws_security_group.immich_sg
}

output "private_subnet" {
  value = aws_subnet.private_subnet
}

output "public_subnet" {
  value = aws_subnet.public_subnet
}