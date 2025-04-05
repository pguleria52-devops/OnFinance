# OnFinane Project Documentation

This repository contains the infrastructure, deployment, and monitoring setup for the **OnFinane** project. It leverages **Terraform** for infrastructure provisioning, **Kubernetes** for application deployment, and **GitHub Actions** for CI/CD automation. The project is designed to be scalable, secure, and highly available.

## Component Breakdown
| Component | Service | Description |
|:-----------|:------------:|------------:|
| Compute	|EKS (Amazon Elastic Kubernetes Service)	|Primary platform to deploy containerized backend/frontend services with auto-scaling, rolling updates, and self-healing features. 
|Networking	|VPC, Public/Private Subnets, Internet Gateway, NAT Gateway	|VPC with subnets in at least 3 Availability Zones (AZs). Public subnets for Load Balancer and NAT Gateway; Private subnets for EKS nodes, RDS, and internal services.
|Load Balancer	|AWS ALB (Application Load Balancer)	|Handles incoming HTTP(S) traffic and distributes it to services in EKS. Supports SSL termination and path-based routing.|
|Storage	|S3, RDS (PostgreSQL), EFS (if needed)	|S3 for static assets, logs, backups. RDS for transactional relational data. EFS for shared persistent storage if required.|
|Authentication & Security	|IAM, KMS, AWS Secrets Manager, Security Groups	|IAM for fine-grained permissions. Secrets Manager for managing credentials securely. KMS for encryption. Security groups for inbound/outbound rules.|
|Monitoring	|CloudWatch, Prometheus + Grafana	|CloudWatch for AWS resources. Prometheus and Grafana in EKS for application metrics and dashboards
|Logging	|CloudWatch Logs, Fluent Bit	|Fluent Bit DaemonSet pushes container logs to CloudWatch. Centralized logging pipeline for observability.|
|CI/CD	|GitHub Actions / CodePipeline → ECR → EKS	|CI/CD pipeline for automated deployment using GitHub Actions or CodePipeline + CodeBuild. Docker images stored in ECR.|
|ETL/API Integration	|Lambda, EventBridge, S3	|Serverless ETL pipelines to pull external data, process, and store in S3.|
|Auto Scaling	|EKS HPA, EC2 Auto Scaling Groups	|Horizontal Pod Autoscaler in EKS; Node Group auto-scaling across AZs.|

## Justification of Services
|Area	|Service	|Justification|
|:-----------|:------------:|------------:|
|Compute	|EKS	|Fully managed Kubernetes, supports scalability and microservices.|
|Storage	|S3, RDS	|S3 for objects, RDS for relational data with HA Multi-AZ deployments.|
|Networking	|VPC, NAT, Subnets	|Custom VPC with subnet segmentation improves security and availability.|
|Load Balancer	|ALB	|Supports path-based routing, SSL, and high availability.|
|Monitoring	|Prometheus, Grafana, CloudWatch	|Robust observability stack for system health and alerts.|
|Logging	|Fluent Bit + CloudWatch	|Lightweight logging daemon that integrates well with AWS.|
|Secrets	|Secrets Manager	|Centralized, secure, and auditable secret storage.|
|CI/CD	|GitHub Actions + ECR + EKS	|Modern CI/CD flow with native AWS deployment.|
|ETL	|Lambda + EventBridge + S3	|Simple, cost-effective, serverless integration for API data ingestion.|

## Security Considerations
- IAM roles with least privilege

- All traffic over HTTPS

- Private subnets for sensitive workloads (EKS nodes, RDS)

- Security Groups & NACLs for layered security

- Audit logging enabled via CloudTrail


## **Project Structure**
OnFinane/ 
- Terraform code/ - Terraform configurations for infrastructure provisioning 
 - main.tf - Main Terraform configuration  
 - variables.tf - Input variables for Terraform  
 - output.tf - Output variables for Terraform 
 - modules/ - Reusable Terraform modules (VPC, EKS, RDS, Security Groups) 
 - backend/ - Backend configuration for Terraform state 
      -  README.md - Documentation for Terraform setup 
 - kubernetes/ - Kubernetes manifests for application deployment 
     - deployment.yml - Deployment configurations for backend and frontend 
     -  service.yml - Service definitions for backend and frontend 
     - config.yml - ConfigMap for environment variables 
     - secret.yml - Secrets for sensitive data │
     - README.md - Documentation for Kubernetes setup
 - monitoring/ - Monitoring and logging configurations
     - alert.tf - Terraform configuration for CloudWatch alarms  
     - daemon.yml - Kubernetes DaemonSet for Fluent Bit logging
     - README.md - Documentation for monitoring setup 
 - .github/workflows/ - GitHub Actions workflows for CI/CD 
    - ci.yml - CI/CD pipeline for linting, testing and for deploying terraform and kubernetes deployment 
 -  README.md - Project-level documentation


## **Features**

### **1. Infrastructure Provisioning**
- **Terraform** is used to provision the following AWS resources:
  - **VPC**: A Virtual Private Cloud with public and private subnets.
  - **EKS**: An Elastic Kubernetes Service cluster for running containerized applications.
  - **RDS**: A managed relational database service.
  - **Security Groups**: Configured for least-privilege access.

### **2. Application Deployment**
- **Kubernetes** is used to deploy the backend and frontend applications.
- Features include:
  - **ConfigMaps** and **Secrets** for managing environment variables and sensitive data.
  - **Liveness** and **Readiness Probes** for health checks.
  - **Horizontal Pod Autoscaler (HPA)** for scaling based on CPU utilization.

### **3. Monitoring and Logging**
- **Prometheus** and **Grafana** for monitoring metrics.
- **AWS CloudWatch** for alarms and logs.
- **Fluent Bit** for centralized logging from Kubernetes nodes.

### **4. CI/CD Pipeline**
- **GitHub Actions** automates the CI/CD process:
  - Linting and testing Terraform code.
  - Building and pushing Docker images to Amazon ECR.
  - Deploying applications to EKS.


## **Setup Instructions**

### **1. Prerequisites**
- AWS CLI configured with appropriate credentials.
- Terraform installed (`>= 1.5.0`).
- kubectl installed and configured for your EKS cluster.
- Docker installed for building container images.

### **2. Infrastructure Provisioning**
1. Navigate to the `Terraform code/` directory.
2. Initialize Terraform:
   ```
   terraform init 
   ```

3. Plan the infrastructure:
```
terraform plan
```
4. Apply the configuration
```
terraform apply -auto-approve
```

## 3. Application Deployment

1. Build and push Docker images to Amazon ECR:
```
docker build -t <repository-name>:latest .
docker tag <repository-name>:latest <AWS_ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com/<repository-name>:latest
docker push <AWS_ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com/<repository-name>:latest
```
2. Create a Secret for ECR Authentication
```
aws ecr get-login-password --region us-east-1 | kubectl create secret docker-registry ecr-secret \
  --docker-server=123456789012.dkr.ecr.us-east-1.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password --region us-east-1)
  ```
3. Update the deployment.yml file with the ECR image URI.
4. Apply the Kubernetes manifests:
```
kubectl apply -f kubernetes/
```

## 4. Secrets Configuration

Add the following secrets to your GitHub repository:

```AWS_ACCESS_KEY_ID```: Your AWS access key.
```AWS_SECRET_ACCESS_KEY```: Your AWS secret key.
```ECR_REPOSITORY_URI```: The URI of your Amazon ECR repository.

## 5. CI/CD Pipeline
- Push changes to the main branch to trigger the GitHub Actions pipeline.
- The pipeline will:
  - Lint and validate Terraform code.
  - Apply Terraform to provision infrastructure.
  - Build and push Docker images to ECR.
  - Deploy the application to EKS.

## Note
- For in depth procedure, go through specific modules  


![Alt text](/image.png)

