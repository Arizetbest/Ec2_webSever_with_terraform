# Provisioning AWS Ec2 webSever Using Terraform
This Terraform script deploys a basic AWS infrastructure to create a Virtual Private Cloud (VPC), subnets across multiple availability zones, an internet gateway, route tables, security groups, a network interface, and an EC2 instance with a user data script.

## Prerequisites
Terraform is installed on your machine.
AWS credentials are configured on your machine.

## Configure your Terraform Provider.tf file
provider "aws" {
  region  = "us-east-1"
  version = "~> 3.0"  # Specify a version constraint if needed
  access_key = "your_access_key"
  secret_key = "your_secret_key"
}

## Define AWS resources using the "AWS" provider
resource "aws_instance" "example_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

## Usage
Clone this repository:
git clone <repository_url>
cd <repository_directory>

## Initialize Terraform:
terraform init
Review and adjust the variables in the variables.tf file if necessary.

## Apply the Terraform configuration:
terraform apply
You will be prompted to confirm the changes. Type yes and press Enter.

## Resources Created
VPC (aws_vpc.testwork): Creates a Virtual Private Cloud with a specified CIDR block.

Internet Gateway (aws_internet_gateway.testGW): Attaches an internet gateway to the VPC.

Route Table (aws_route_table.testRT): Sets up a route table with a default route to the internet via the internet gateway.

Subnets (aws_subnet.testSubnet1 - aws_subnet.testSubnet4): Creates subnets across different availability zones.

Route Table Associations (aws_route_table_association.test-RT1-sub-assoc - aws_route_table_association.test-RT4-sub-assoc): Associates subnets with the route table.

Security Group (aws_security_group.TestSG): Configures a security group allowing traffic on ports 80, 443, and 22.

Network Interface (aws_network_interface.testNT): Creates a network interface attached to one of the subnets and security groups.

Elastic IP (aws_eip.TestEIP): Allocates an Elastic IP and associates it with the network interface.

EC2 Instance (aws_instance.test-web-server): Launches an EC2 instance with a user data script to set up a basic web server.

## Cleanup
To destroy the created resources, run:
terraform destroy
You will be prompted to confirm the destruction. Type yes and press Enter.

Note: Ensure that you understand the implications of destroying resources, as it will permanently delete them.
