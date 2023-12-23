# Create a VPC
resource "aws_vpc" "testwork" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "testserver"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "testGW" {
  vpc_id = aws_vpc.testwork.id
  tags = {
    Name = "gateway"
  }
}

# setting up the route table
resource "aws_route_table" "testRT" {
  vpc_id = aws_vpc.testwork.id


  route {
    # pointing to the internet
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testGW.id
  }

tags = {
  Name = "testRT"
}
}

# Setting up the Subnet
resource "aws_subnet" "testSubnet1" {
  vpc_id = aws_vpc.testwork.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "testSN1a"
  }
}

resource "aws_subnet" "testSubnet2" {
  vpc_id = aws_vpc.testwork.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "testSN1b"
  }
}

resource "aws_subnet" "testSubnet3" {
  vpc_id = aws_vpc.testwork.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "testSN1c"
  }
}

resource "aws_subnet" "testSubnet4" {
  vpc_id = aws_vpc.testwork.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1d"

  tags = {
    Name = "testSN1d"
  }
}  

 
resource "aws_route_table_association" "test-RT1-sub-assoc" {
  subnet_id = aws_subnet.testSubnet1.id
  route_table_id = aws_route_table.testRT.id
  }
  
  resource "aws_route_table_association" "test-RT2-sub-assoc" {
  subnet_id = aws_subnet.testSubnet2.id
  route_table_id = aws_route_table.testRT.id
  }

   resource "aws_route_table_association" "test-RT3-sub-assoc" {
  subnet_id = aws_subnet.testSubnet3.id
  route_table_id = aws_route_table.testRT.id
  }
   resource "aws_route_table_association" "test-RT4-sub-assoc" {
  subnet_id = aws_subnet.testSubnet4.id
  route_table_id = aws_route_table.testRT.id
  }

  #Creating a Security Group

  resource "aws_security_group" "TestSG" {
    description = "Enable web traffic for the project"
    vpc_id = aws_vpc.testwork.id

    ingress {
      description = "HTTPs traffic"
      from_port = 443
      to_port =   443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "HTTP traffic"
      from_port = 80
      to_port =   80
      protocol =  "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "SSH port"
      from_port =  22
      to_port =    22
      protocol =   "tcp"
      cidr_blocks =  ["0.0.0.0/0"]
    }

    egress {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "NSG"
      }

    
  }

  # Creating a new network interface
  resource "aws_network_interface" "testNT" {
    subnet_id = aws_subnet.testSubnet1.id
    private_ips = ["10.0.1.10"]
    security_groups = ["sg-07c393a0a410eb481"]
  }

  # Attaching an elastic IP to the network interface

  resource "aws_eip" "TestEIP" {
    domain = "vpc" # Set to "vpc" for an Elastic IP in a VPC
    network_interface = aws_network_interface.testNT.id
    associate_with_private_ip = "10.0.1.10"
  }

 # 9. Create aws_instance

resource "aws_instance" "test-web-server" {
   ami                    = "ami-03a6eaae9938c858c"
   instance_type          = "t2.micro"
   availability_zone = "us-east-1a"
   key_name               = "testKP"
depends_on                = [aws_eip.TestEIP]
   network_interface {
     device_index         = 0
     network_interface_id = aws_network_interface.testNT.id
   }

   user_data = <<-EOF
			#!/bin/bash
			sudo su
			yum update -y
			yum install http -y
			systemctl restart httpd
			systemctl enable httpd
			echo "Welcome to the Test webser Home Page" > /var/www/html/index.html
			EOF
   tags = {
     Name = "test-web-server"
   }
 }