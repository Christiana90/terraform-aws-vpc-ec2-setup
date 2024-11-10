provider "aws" {
  region = var.region
}
#note the name is locals and when calling it in the configurations is "local". 
locals {
  created     = var.locals_created
  environment = var.locals_environment
}


resource "aws_vpc" "my_vpc" {
  cidr_block = var.Vpc_cidr_block
  tags = {
    Name = "${local.created}_vpc"
    env  = local.environment
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.Public_subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "${local.created}_public_subnet"
    env  = local.environment
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${local.created}_internetgateway"

  }
}

resource "aws_route_table" "public_routetable" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${local.created}_routetable" #interpolation
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public_routetable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

#connecting the subnet to the routetable

resource "aws_route_table_association" "public_assciosiation" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public_routetable.id
}

resource "aws_security_group" "my_securitygroup" {
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.created}_securitygroup"
    env  = local.environment
  }
}

resource "aws_instance" "EC2_for_different_department" {
  for_each = {
    "production department"  = "t2.micro"
    "testing department"     = "t2.nano"
    "development department" = "t2.small"
  }
  ami                    = var.ami_id
  instance_type          = each.value
  subnet_id              = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.my_securitygroup.id]
  tags = {
    Name               = "${local.created}_EC2_Intance"
    env                = each.key
    Administrator_info = <<QQQ
        Cloud Engineer -Christiana
        DEvops department
        ID : 1234567890
        QQQ         
  }
}

output "vpc_id" {
  value       = aws_vpc.my_vpc.id
  description = "The VPC_ID is "
}


output "ec2_public_ip" {
  value = {
    for key, instance in aws_instance.EC2_for_different_department : key => {
      public_ip     = instance.public_ip
      private_ip    = instance.private_ip
      instance_type = instance.instance_type
      subnet_id     = instance.subnet_id
    }
  }
}



# we learn about registry.terraform.io,
# terraform.lock.hcl, (lock the version of ) 
#terraform fmt (format the code to hcl format)
#terraform validate (to check if there are error in the main terraform code)
#terraform init (installs all the plugins for the provided cloud providers)
#terraform plan (list the resource to be executed, allows you to have preview of what resouces thast will be created)
#terraform apply ( exeute the code in the terraform file)
#terraform apply -auto-approve
#terraform destroy( delete)
#terraform destroy -auto-approve
#terraform state (start the command that you can execute with it)
#terraform state list (list resources in the state file, resourceing running in terraform)
#terraform output (print all the output started in the terraform file)
#terraform graph (list of the implicite dependency)
#terraform version (to see the version of terraform you have installed)
#terraform apply --auto-approve( used when you want to apply the terraform code without being prompted)
#terraform destroy --auto-approve( used when you want to destroy the terraform code without being promptederraform destroy --auto-approve
#terraform apply -var-file example.tfvars
#terraform show
#terraform state show
#terraform taint  The terraform taint command is specifically for marking a resource to be destroyed and recreated on the next apply.
# depends_on (used to tell terraform to wait for the resource to be created before creating the next resource)
#terraform refresh (used to tell terraform to refresh the state file)
