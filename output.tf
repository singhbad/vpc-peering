output "vpc_ids" {
  description = "IDs of created VPCs"
  value       = { for k, v in aws_vpc.vpcs : k => v.id }
}

output "instance_private_ips" {
  description = "Private IPs of EC2 instances"
  value       = { for k, v in aws_instance.instances : k => v.private_ip }
}

output "instance_public_ips" {
  description = "Public IPs of EC2 instances"
  value       = { for k, v in aws_instance.instances : k => v.public_ip }
}

output "peering_connection_ids" {
  description = "VPC Peering Connection IDs"
  value = {
    web_to_db = aws_vpc_peering_connection.web_to_db.id
    app_to_db = aws_vpc_peering_connection.app_to_db.id
  }
}