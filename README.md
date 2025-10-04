# ⚠️ WIP

# NestJS Clean Architecture Infrastructure

This repository contains the Terraform infrastructure-as-code for deploying a NestJS Clean Architecture application on AWS using a serverless containerized approach.

## Architecture Overview

The infrastructure provisions the following AWS resources:

- **Amazon ECR**: Container registry for storing Docker images
- **Amazon S3**: Backend storage for Terraform state with versioning enabled
- **IAM Roles & Policies**: Secure access management for CI/CD, Terraform operations, and application deployment
- **OIDC Provider**: GitHub Actions integration for credential-free deployments

## Infrastructure Components

### Container Registry (ECR)
- Repository name: `ci-repositories`
- Image scanning enabled for security
- Mutable image tags for development flexibility

### State Management
- **S3 Backend**: Remote state stored in `05-nest-clean-infra-backend` bucket
- **State File Location**: `state/terraform.tfstate`
- **S3 Bucket**: Separate `05-nest-clean-infra` bucket for general storage with versioning enabled
- **Region**: us-east-2

### Identity & Access Management
- **GitHub OIDC Provider**: Enables secure authentication from GitHub Actions
- **ECR Role**: Allows GitHub Actions to push/pull container images and manage App Runner
- **Terraform Role**: Allows GitHub Actions to manage infrastructure (ECR, IAM, S3)
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

### Initial Setup (First Time)

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

3. **Create S3 backend bucket** (if not exists)
   ```bash
   aws s3 mb s3://05-nest-clean-infra-backend --region us-east-2
   ```

4. **Initialize Terraform**
   ```bash
   terraform init
   ```

5. **Plan and apply infrastructure**
   ```bash
   terraform plan
   terraform apply
   ```

### Automated Deployment via GitHub Actions

Once the infrastructure is provisioned and GitHub secrets are configured, pushes to the `main` branch will automatically:
1. Run Terraform plan
2. Generate cost estimates with Infracost
3. Apply infrastructure changes

## Configuration

### Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `profile` | AWS CLI profile name | `""` | Yes |

### Terraform Files

- `main.tf` - Provider configuration, AWS region settings, S3 backend, and state bucket
- `ecr.tf` - ECR repository definition
- `iam.tf` - IAM roles, policies, and OIDC provider
- `variables.tf` - Input variable definitions
- `.github/workflows/ci.yaml` - GitHub Actions CI/CD pipeline

## GitHub Actions Integration

The infrastructure is designed to work with GitHub Actions for CI/CD. The OIDC provider allows GitHub Actions to:

1. Authenticate with AWS without storing credentials
2. Manage infrastructure with Terraform (via `tf_role`)
3. Push Docker images to ECR (via `ecr_role`)
4. Deploy applications using AWS App Runner

### CI/CD Pipeline

The `.github/workflows/ci.yaml` workflow automates:
- **Terraform Workflow**: Initialize, format check, validate, plan, and apply infrastructure changes
- **Cost Estimation**: Infracost integration to estimate infrastructure costs before applying changes
- **Automated Deployment**: Terraform apply runs automatically on pushes to main branch

### Required GitHub Secrets

- `AWS_ROLE_ID`: ARN of the Terraform role for AWS authentication
- `AWS_REGION`: AWS region (us-east-2)
- `AWS_PROFILE`: AWS profile name for Terraform
- `INFRACOST_API_KEY`: API key for Infracost cost estimation

### Required GitHub Variables

- `TF_VERSION`: Terraform version to use (e.g., "1.5.0")

### Required GitHub Repository Configuration

The OIDC trust policies are configured for:
- **Application Repository**: `viniciusferreira7/05-nest-clean` (branch: `main`)
- **Infrastructure Repository**: `viniciusferreira7/05-nest-clean-infra` (branch: `main`)

To use with different repositories, update the `token.actions.githubusercontent.com:sub` conditions in [iam.tf](iam.tf).

## Security Considerations

- All resources are tagged with `IAC = "True"` for identification
- ECR repository has automatic vulnerability scanning enabled
- IAM roles follow least-privilege principles
- OIDC integration eliminates the need for long-lived AWS credentials
- S3 bucket versioning enabled for state file recovery
- S3 backend with lifecycle policy to prevent accidental state deletion
- Separate IAM roles for Terraform operations and application deployment

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

- **S3 Storage**: Minimal costs for state file storage (few KB)
- **ECR Storage**: Charges based on repository size
- **Data Transfer**: Costs for pulling images
- **IAM**: No charges for roles and policies
- **App Runner**: Charges apply when applications are deployed
- **Infracost**: Free tier available for cost estimation

Use Infracost to preview estimated costs before applying changes.

## Support

This infrastructure supports the deployment of NestJS applications following Clean Architecture principles with containerized deployment on AWS App Runner.