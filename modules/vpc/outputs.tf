output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "VPC CIDR 블록"
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "public 서브넷 ID 목록 (AZ 순서)"
  value       = [for az in var.azs : aws_subnet.public[az].id]
}

output "private_subnet_ids" {
  description = "private 서브넷 ID 목록 (AZ 순서)"
  value       = [for az in var.azs : aws_subnet.private[az].id]
}

output "nat_public_ips" {
  description = "NAT Gateway 공인 IP 목록"
  value       = [for eip in aws_eip.nat : eip.public_ip]
}
