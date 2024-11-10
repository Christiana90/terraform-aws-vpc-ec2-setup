# Terraform AWS Infrastructure Setup

This Terraform project sets up a configurable AWS infrastructure, including a VPC, public subnet, internet gateway, route table, security group, and multiple EC2 instances allocated for different departments. This configuration provides a secure and networked environment in a public subnet, ideal for deploying applications or development environments. Additionally, the project includes flexible variables and local values, making it easy to adapt configurations across different environments, such as development, testing, and production.

## Table of Contents
- [Architecture Overview](#architecture-overview)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Variables](#variables)
- [Outputs](#outputs)

---

## Architecture Overview
The project provisions the following AWS resources:
- **VPC**: A Virtual Private Cloud with a customizable CIDR block.
- **Public Subnet**: A public subnet with auto-assign public IP enabled.
- **Internet Gateway**: Provides internet access to the VPC.
- **Route Table and Route**: Routes for internet access, associated with the public subnet.
- **Security Group**: Configured with inbound rules for SSH and HTTP.
- **EC2 Instances**: EC2 instances configured for different departments (production, testing, development) with specified instance types.

### Diagram
```
VPC (Virtual Private Cloud)
└── Public Subnet
    ├── Internet Gateway
    ├── Route Table
    ├── Security Group (SSH and HTTP access)
    └── EC2 Instances (for different departments)
```

---

## Project Structure
The configuration is structured as follows:
- **Provider**: Defines AWS as the provider and specifies the region.
- **Local Variables**: Holds the created resource name prefix and environment.
- **VPC, Subnet, Internet Gateway, Route Table**: Core networking resources.
- **Security Group**: Defines inbound rules for access.
- **EC2 Instances**: Configures instances for different departments with tags and metadata.
- **Outputs**: Provides information on the created VPC and EC2 instances.

---

## Prerequisites
1. **Terraform**: Ensure that Terraform is installed. You can download it from [Terraform's official website](https://www.terraform.io/downloads).
2. **AWS Account**: You need an AWS account with permissions to create the following resources: VPC, Subnets, Internet Gateway, Route Table, Security Groups, and EC2 Instances.
3. **AWS CLI** (optional): For authentication setup. Run `aws configure` to set up access and secret keys.

---

## Usage

### Step 1: Clone the Repository
Clone this repository to your local machine.
```bash
git clone <repository-url>
cd <repository-folder>
```

### Step 2: Initialize the Terraform Project
Run the following command to initialize the working directory. This will download the AWS provider.
```bash
terraform init
```

### Step 3: Define Input Variables
Create a `terraform.tfvars` file in the root directory to specify values for the required variables:
```hcl
Vpc_cidr_block           = "10.0.0.0/16"
Public_subnet_cidr_block = "10.0.1.0/24"
availability_zone        = "us-west-2a"
ingress_cidr_blocks      = ["YOUR_IP/32"] # For restricted SSH access
ami_id                   = "ami-xxxxxx"   # Replace with a valid AMI ID
region                   = "us-west-2"
locals_created           = "myproject"
locals_environment       = "dev"
```

### Step 4: Review the Execution Plan
Run `terraform plan` to review the resources that will be created.
```bash
terraform plan
```

### Step 5: Apply the Configuration
Apply the configuration to create the resources on AWS.
```bash
terraform apply
```
Confirm the apply operation to proceed.

### Step 6: Destroy Resources (Optional)
To remove all the resources created by this configuration, run:
```bash
terraform destroy
```

---

## Variables
Below are the key input variables used in this configuration:

| Variable                    | Description                                        | Type    | Example             |
|-----------------------------|----------------------------------------------------|---------|---------------------|
| `Vpc_cidr_block`            | CIDR block for the VPC                             | String  | `"10.0.0.0/16"`    |
| `Public_subnet_cidr_block`  | CIDR block for the public subnet                   | String  | `"10.0.1.0/24"`    |
| `availability_zone`         | Availability zone for the subnet                   | String  | `"us-west-2a"`     |
| `ingress_cidr_blocks`       | Allowed CIDR blocks for security group ingress     | List    | `["YOUR_IP/32"]`   |
| `ami_id`                    | AMI ID for the EC2 instances                       | String  | `"ami-xxxxxx"`     |
| `region`                    | AWS region for resource creation                   | String  | `"us-west-2"`      |
| `locals_created`            | Prefix for naming resources                        | String  | `"myproject"`      |
| `locals_environment`        | Environment name (e.g., dev, prod)                 | String  | `"dev"`            |

---

## Outputs
The following outputs provide information about the created resources:

| Output Name        | Description                                       |
|--------------------|---------------------------------------------------|
| `vpc_id`           | ID of the created VPC                             |
| `ec2_public_ip`    | Public and private IPs of each EC2 instance       |

---

## Notes
- **Security Group Rules**: The security group allows SSH (port 22) and HTTP (port 80) access. For production environments, ensure that the `ingress_cidr_blocks` variable is restricted for security.
- **Instance Metadata**: Each EC2 instance is tagged with department information (production, testing, development) and administrator metadata.

This flexible configuration, with customizable variables and local values, makes it easy to adapt the infrastructure for different environments, from development to production.