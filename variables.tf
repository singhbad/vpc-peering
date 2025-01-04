variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidrs" {
  description = "CIDR blocks for VPCs"
  type        = map(string)
}

variable "availability_zones" {
  description = "AZs for the VPCs"
  type        = map(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "enable_public_ip" {
  description = "Enable public IP on launch for subnets"
  type        = bool
}
