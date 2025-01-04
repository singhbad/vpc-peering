Multi-VPC AWS Infrastructure with Terraform
This project implements a multi-VPC architecture in AWS using Terraform, consisting of three VPCs (Database, Web Server, and Application Server) with EC2 instances and VPC peering connections.
Architecture Overview

Database VPC: Hosts the database server in a separate availability zone
Web Server VPC: Hosts the web server
Application Server VPC: Hosts the application server
VPC peering connections between Web->DB and App->DB
All instances are free-tier eligible (t2.micro)

Prerequisites

Terraform (v0.12 or later)
AWS CLI configured with appropriate credentials
SSH key pair for EC2 instance access

Project Structure
plaintextCopy.
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Variable declarations
├── terraform.tfvars        # Variable definitions
├── outputs.tf              # Output definitions
├── provider.tf             # Provider configuration
└── backend.tf             # S3 backend configuration
Variables
Key variables defined in terraform.tfvars:

aws_region: AWS region for deployment
vpc_cidrs: CIDR blocks for each VPC
availability_zones: AZ configuration for each VPC
instance_type: EC2 instance type
enable_public_ip: Toggle for public IP assignment

Usage

Clone the repository:
bashCopygit clone <repository-url>
cd <repository-name>

Initialize Terraform:
bashCopyterraform init

Review the planned changes:
bashCopyterraform plan

Apply the configuration:
bashCopyterraform apply

To destroy the infrastructure:
bashCopyterraform destroy


Features
1. VPC Configuration

Three separate VPCs for different components
Custom CIDR ranges
Internet Gateway for each VPC
Public subnets with auto-assigned public IPs

2. Security

Security groups configured for each instance
ICMP (ping) allowed between VPCs
SSH access from anywhere (port 22)
VPC peering for secure inter-VPC communication

3. EC2 Instances

Amazon Linux 2 AMI
t2.micro instances (free tier eligible)
Public IP addresses for access
Placed in specified availability zones

4. State Management

Remote state storage in S3
Bucket versioning enabled
State file locking with DynamoDB (optional)

Outputs

VPC IDs
EC2 instance private and public IPs
VPC peering connection IDs

Common Issues and Troubleshooting
1. Connectivity Issues

Verify security group rules
Check route table configurations
Ensure VPC peering connections are active

2. SSH Access

Verify key pair is correctly specified
Check security group ingress rules
Ensure public IP is assigned

Best Practices Implemented

Use of variables for reusability
Proper resource tagging
Security group restrictions
VPC peering for secure communication
S3 backend for state management

Contributing

Fork the repository
Create a feature branch
Commit your changes
Push to the branch
Create a Pull Request

