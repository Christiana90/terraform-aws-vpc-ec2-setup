# for the local variables
variable "locals_created" {
  description = "Enter the created by XXXX"
}
variable "locals_environment" {
  description = "Enter the environment"
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2" # Set a default, or override in .tfvars file
}

variable "availability_zone" {
  description = "Availability zone for subnet deployment"
  type        = string
  default     = "us-west-2a"
}


variable "ingress_cidr_blocks" {
  description = "Allowed CIDR blocks for security group ingress"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Adjust to restrict access as needed
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Enter the EC2  instance type"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  sensitive   = true
}

variable "Vpc_cidr_block" {
  description = "Enter the Vpc_Cidr_Block"
}

variable "Public_subnet_cidr_block" {
  description = "Enter the public_subnet_Cidr_Block"
}