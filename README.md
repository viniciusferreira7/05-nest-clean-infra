# ⚠️ WIP

# NestJS Clean Architecture Infrastructure

This repository contains the Terraform infrastructure-as-code for deploying a NestJS Clean Architecture application on AWS using a serverless containerized approach.

## Architecture Overview

The infrastructure provisions the following AWS resources:

- **Amazon ECR**: Container registry for storing Docker images
- **IAM Roles & Policies**: Secure access management for CI/CD and application deployment
- **OIDC Provider**: GitHub Actions integration for credential-free deployments

## Infrastructure Components

### Container Registry (ECR)
- Repository name: `ci-repositories`
- Image scanning enabled for security
- Mutable image tags for development flexibility

### Identity & Access Management
- **GitHub OIDC Provider**: Enables secure authentication from GitHub Actions
- **ECR Role**: Allows GitHub Actions to push/pull container images
- **App Runner Role**: Enables AWS App Runner to pull images from ECR

### Security Features
- OIDC-based authentication (no long-lived AWS credentials)
- Least-privilege IAM policies
- Automated vulnerability scanning on container images
- Restricted access to specific GitHub repository and branch

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- AWS CLI configured with appropriate credentials
- AWS profile with permissions to create IAM roles, ECR repositories, and OIDC providers

## Quick Start

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd 05-nest-clean-infra
   ```

2. **Configure AWS profile**
   ```bash
   # Update terraform.tfvars with your AWS profile
   echo 'profile = "your-aws-profile"' > terraform.tfvars
   ```

3. **Initialize Terraform**
   ```bash
   terraform init
   ```

4. **Plan and apply infrastructure**
   ```bash
   terraform plan
   terraform apply
   ```

## Configuration

### Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `profile` | AWS CLI profile name | `""` | Yes |

### Terraform Files

- `main.tf` - Provider configuration and AWS region settings
- `ecr.tf` - ECR repository definition
- `iam.tf` - IAM roles, policies, and OIDC provider
- `variables.tf` - Input variable definitions

## GitHub Actions Integration

The infrastructure is designed to work with GitHub Actions for CI/CD. The OIDC provider allows GitHub Actions to:

1. Authenticate with AWS without storing credentials
2. Push Docker images to ECR
3. Deploy applications using AWS App Runner

### Required GitHub Repository Configuration

The OIDC trust policy is configured for:
- Repository: `viniciusferreira7/05-nest-clean`
- Branch: `main`

To use with a different repository, update the `token.actions.githubusercontent.com:sub` condition in `iam.tf`.

## Security Considerations

- All resources are tagged with `IAC = "True"` for identification
- ECR repository has automatic vulnerability scanning enabled
- IAM roles follow least-privilege principles
- OIDC integration eliminates the need for long-lived AWS credentials

## Development Workflow

1. Make infrastructure changes
2. Format code: `terraform fmt`
3. Validate configuration: `terraform validate`
4. Plan changes: `terraform plan`
5. Apply changes: `terraform apply`
6. Commit and push to trigger CI/CD

## Cleanup

To destroy all infrastructure:

```bash
terraform destroy
```

## Cost Considerations

- ECR storage charges based on repository size
- Data transfer costs for pulling images
- No charges for IAM roles and policies
- App Runner charges apply when applications are deployed

## Support

This infrastructure supports the deployment of NestJS applications following Clean Architecture principles with containerized deployment on AWS App Runner.