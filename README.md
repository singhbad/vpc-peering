# Multi-VPC AWS Infrastructure with Terraform

[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)

This project implements a multi-VPC architecture in AWS using Terraform, consisting of three VPCs (Database, Web Server, and Application Server) with EC2 instances and VPC peering connections.

## 🏗️ Architecture Overview

- **Database VPC**: Hosts the database server in a separate availability zone
- **Web Server VPC**: Hosts the web server
- **Application Server VPC**: Hosts the application server
- VPC peering connections between Web→DB and App→DB
- All instances are free-tier eligible (t2.micro)

## 📋 Prerequisites

- Terraform (v0.12 or later)
- AWS CLI configured with appropriate credentials
- SSH key pair for EC2 instance access

## 📁 Project Structure

```plaintext
.
├── main.tf           # Main Terraform configuration
├── variables.tf      # Variable declarations
├── terraform.tfvars  # Variable definitions
├── outputs.tf        # Output definitions
├── provider.tf       # Provider configuration
└── backend.tf        # S3 backend configuration
```

## 🔧 Variables

Key variables defined in `terraform.tfvars`:

- `aws_region`: AWS region for deployment
- `vpc_cidrs`: CIDR blocks for each VPC
- `availability_zones`: AZ configuration for each VPC
- `instance_type`: EC2 instance type
- `enable_public_ip`: Toggle for public IP assignment

[Rest of the README content remains the same...]
