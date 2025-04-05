# Terraform Code Documentation

This folder contains Terraform configurations for provisioning and managing the infrastructure for the OnFinane project. It includes reusable modules for creating VPCs, EKS clusters, RDS databases, and security groups, as well as backend configurations for managing Terraform state.


## 1. Backend Configuration

The `backend/` folder contains configurations for managing Terraform state using an S3 bucket and DynamoDB table.

### Files:
- **`main.tf`**: Defines the S3 bucket and DynamoDB table for storing and locking Terraform state.

### Key Commands:
- Initialize the backend:
```
terraform init
```
- Apply the backend configuration:
```
terraform apply
```

## 2. Modules
The modules/ folder contains reusable Terraform modules for creating infrastructure components.

### 2.1 VPC Module

The vpc/ module provisions a Virtual Private Cloud (VPC) with public and private subnets, NAT gateways, and route tables.

Files:
- main.tf: Defines the VPC, subnets, NAT gateways, and route tables.
- variables.tf: Input variables for the VPC module.
- output.tf: Outputs for retrieving VPC details.

Outputs:

- vpc_id: The ID of the created VPC.
- public_subnet: IDs of the public subnets.
- private_subnet: IDs of the private subnets.

### 2.2 EKS Module

The eks/ module provisions an Elastic Kubernetes Service (EKS) cluster and associated resources.

Files:
- main.tf: Defines the EKS cluster, IAM roles, and node groups.
- variables.tf: Input variables for the EKS module.
- output.tf: Outputs for retrieving EKS details.

Outputs:

- cluster_endpoint: The endpoint of the EKS cluster.
- cluster_name: The name of the EKS cluster.

### 2.3 RDS Module

The rds/ module provisions a Relational Database Service (RDS) instance.

Files:
- main.tf: Defines the RDS instance and its configuration.
- variables.tf: Input variables for the RDS module.
- output.tf: Outputs for retrieving RDS details.

Outputs:

- db_instance_id: The ID of the RDS instance.
- db_endpoint: The endpoint of the RDS instance.
- db_name: The name of the database.

### 2.4 Security Group Module

The security_group/ module provisions security groups for controlling inbound and outbound traffic.

Files:
- main.tf: Defines the security group and its rules.
- variables.tf: Input variables for the security group module.
- output.tf: Outputs for retrieving security group details.

Outputs:
- security_group_id: The ID of the created security group.
- security_group_name: The name of the security group.

### 3. Main Configuration

The main.tf file is the entry point for provisioning the infrastructure. It uses the modules to create the VPC, EKS cluster, RDS instance, and security groups.

Key Commands:
- Initialize Terraform:
```
terraform init
```
- Plan the infrastructure
```
terraform plan
```
- Apply the configuration
```
terraform apply
```

### 4. Variables

The variables.tf file defines input variables for customizing the infrastructure. Key variables include:

- region: AWS region (default: us-east-1).
- vpc_cidr: CIDR block for the VPC.
- availability_zones: List of availability zones.
- cluster_name: Name of the EKS cluster.
- db_name: Name of the RDS database.

### 5. Outputs

The output.tf file defines outputs for retrieving details about the provisioned resources. Uncomment the required outputs to use them.

### Notes

- Ensure required ports are open in your security groups for services like EKS and RDS.
- Customize configurations as needed for your environment.