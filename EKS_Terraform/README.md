# AWS EKS Auto Mode Infrastructure using Terraform

## Project Overview
This project provisions a complete Amazon EKS Auto Mode environment using Terraform. It automates AWS networking, IAM, Kubernetes, Helm deployments, and GitOps setup with ArgoCD. The infrastructure follows Infrastructure as Code (IaC) best practices, making deployments consistent, repeatable, and version-controlled.

---

## Architecture

<img width="1536" height="1024" alt="ChatGPT Image Jul 27, 2026, 09_45_47 PM" src="https://github.com/user-attachments/assets/862997f5-2339-42ac-9bee-ff231d69db98" />


---

## Features

- Amazon EKS Auto Mode Cluster
- Custom VPC with Public & Private Subnets
- Internet Gateway & NAT Gateway
- IAM Roles & IRSA
- AWS Load Balancer Controller
- Amazon EBS CSI Driver
- ArgoCD Installation using Helm
- ALB Ingress Configuration
- GitOps Ready Infrastructure
- Terraform based Infrastructure Provisioning

---

## Technologies Used

- Terraform
- AWS
- Amazon EKS Auto Mode
- Kubernetes
- Helm
- ArgoCD
- AWS Load Balancer Controller
- Amazon EBS CSI Driver

---

## Repository Structure

### providers.tf
Configures AWS, Kubernetes and Helm providers required to provision AWS resources and manage Kubernetes components.

### vpc.tf
Creates the networking infrastructure including VPC, Public & Private Subnets, Internet Gateway, NAT Gateway, Route Tables and Route Associations.

### security_group.tf
Creates security groups and configures inbound and outbound rules for HTTP, HTTPS and SSH access.

### roles.tf
Creates IAM Roles, Policy Attachments and IAM Roles for Service Accounts (IRSA) required by Amazon EKS and Kubernetes add-ons.

### lb_iam_policy.json
Defines the IAM policy used by the AWS Load Balancer Controller to create and manage ALBs, Target Groups, Listeners and Security Groups.

### eks.tf
Creates the Amazon EKS Auto Mode cluster, authentication configuration and compute resources.

### helm.tf
Deploys Kubernetes applications using Helm, including:
- AWS Load Balancer Controller
- ArgoCD

### instance.tf
Creates an EC2 instance used as the administration server for Terraform, kubectl, Helm and AWS CLI operations.


---

## Deployment Workflow

```text
Terraform Init
      ↓
Terraform Plan
      ↓
Terraform Apply
      ↓
AWS Infrastructure
      ↓
VPC & Networking
      ↓
IAM Roles & IRSA
      ↓
Amazon EKS Auto Mode
      ↓
Helm Deployments
      ↓
AWS Load Balancer Controller
      ↓
ArgoCD
      ↓
ALB Ingress
      ↓
GitOps Ready Cluster
```

---

## Deployment Steps

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

Configure kubectl

```bash
aws eks update-kubeconfig --region us-east-1 --name <cluster-name>
```

Verify Cluster

```bash
kubectl get nodes
kubectl get pods -A
kubectl get svc -A
kubectl get ingress -A
```

---

## AWS Resources Created

- VPC
- Public Subnets
- Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups
- IAM Roles
- Amazon EKS Auto Mode Cluster
- AWS Load Balancer Controller
- Amazon EBS CSI Driver
- ArgoCD
- Application Load Balancer

---

## Author

**Bandaru Nihanth Sai**

  DevOps Engineer

**Skills:** AWS • Terraform • Kubernetes • Docker • Helm • Git • ArgoCD • GitOps • Amazon EKS
