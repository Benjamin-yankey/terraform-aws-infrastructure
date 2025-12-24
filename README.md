# Terraform AWS Infrastructure Project

## Project Overview

This project demonstrates Infrastructure as Code (IaC) using Terraform to deploy foundational AWS infrastructure with remote state management.

## Architecture

The infrastructure includes:

- **VPC** with custom CIDR block
- **Public Subnet** with internet connectivity
- **Internet Gateway** for external access
- **Route Table** with routes to IGW
- **Security Group** with SSH and HTTP access
- **EC2 Instance** (t2.micro) running Amazon Linux 2 with Apache web server
- **S3 Bucket** for Terraform state storage (versioned and encrypted)
- **DynamoDB Table** for state locking

## Prerequisites

- Terraform >= 1.5.0
- AWS CLI configured with appropriate credentials
- AWS account with necessary permissions
- Your public IP address

## Project Structure

```
terraform-aws-infrastructure/
├── main.tf                 # Main infrastructure configuration
├── variables.tf            # Variable definitions
├── outputs.tf              # Output definitions
├── backend.tf              # Remote backend configuration
├── terraform.tfvars        # Variable values (not committed)
├── .gitignore              # Git ignore file
├── README.md               # This file
└── screenshots/            # Evidence screenshots
    ├── terraform-init.png
    ├── terraform-plan.png
    ├── terraform-apply.png
    ├── backend-migration.png
    ├── ec2-console.png
    ├── vpc-console.png
    ├── security-group.png
    ├── s3-bucket.png
    ├── dynamodb-table.png
    ├── web-browser.png
    └── terraform-destroy.png
```

## Configuration

### Step 1: Clone and Configure

1. Clone this repository
2. Copy `terraform.tfvars.example` to `terraform.tfvars`
3. Update `terraform.tfvars` with your values:
   - `my_ip`: Your public IP address (format: x.x.x.x/32)
   - `backend_bucket_name`: Globally unique S3 bucket name

### Step 2: Initial Deployment

```bash
# Initialize Terraform3
terraform init

# Format code
terraform fmt

# Validate configuration
terraform validate

# Preview changes
terraform plan

# Deploy infrastructure
terraform apply
```

### Step 3: Configure Remote Backend

After initial deployment:

1. Edit `backend.tf` and uncomment the backend configuration
2. Update the bucket name to match your `backend_bucket_name`
3. Migrate state to remote backend:

```bash
terraform init -migrate-state
```

## Deployed Resources

### Network Resources

- **VPC**: 10.0.0.0/16
- **Public Subnet**: 10.0.1.0/24
- **Internet Gateway**: Attached to VPC
- **Route Table**: Routes 0.0.0.0/0 to IGW

### Compute Resources

- **EC2 Instance**: t2.micro, Amazon Linux 2
- **Security Group**:
  - Inbound: SSH (22) from your IP
  - Inbound: HTTP (80) from anywhere
  - Outbound: All traffic allowed

### Backend Resources

- **S3 Bucket**:
  - Versioning enabled
  - Encryption enabled (AES256)
  - Public access blocked
- **DynamoDB Table**:
  - On-demand billing
  - Hash key: LockID

## Accessing the Infrastructure

### Web Server

After deployment, get the public IP:

```bash
terraform output instance_public_ip
```

Access in browser: `http://<public-ip>`

### SSH Access

```bash
ssh -i your-key.pem ec2-user@<public-ip>
```

## Outputs

The configuration provides the following outputs:

- `vpc_id`: VPC identifier
- `instance_public_ip`: EC2 instance public IP
- `instance_public_dns`: EC2 instance public DNS
- `s3_bucket_name`: State bucket name
- `dynamodb_table_name`: Lock table name
- `web_url`: Complete URL to access web server
- `deployment_summary`: Summary of all deployed resources

View outputs:

```bash
terraform output
```

## Remote State Management

### State Storage

- **Location**: S3 bucket with encryption and versioning
- **Locking**: DynamoDB table prevents concurrent modifications
- **Benefits**:
  - Team collaboration
  - State history and rollback capability
  - Concurrent access protection

### Verifying Backend

```bash
# Check state file in S3
aws s3 ls s3://<your-bucket-name>/

# Check lock table
aws dynamodb describe-table --table-name terraform-state-lock
```

## Cleanup

### Destroy Infrastructure

```bash
terraform destroy
```

### Remove Backend Resources (Optional)

```bash
# Empty and delete S3 bucket
aws s3 rm s3://<your-bucket-name> --recursive
aws s3 rb s3://<your-bucket-name>

# Delete DynamoDB table
aws dynamodb delete-table --table-name terraform-state-lock
```

## Cost Considerations

All resources use AWS Free Tier where available:

- **EC2 t3.micro**: 750 hours/month free
- **S3**: 5GB storage, 20,000 GET requests free
- **DynamoDB**: 25GB storage, on-demand pricing
- **Data Transfer**: First 100GB/month free

## Security Best Practices

1. **State File**: Contains sensitive data, stored encrypted in S3
2. **SSH Access**: Restricted to your IP only
3. **Credentials**: Never commit AWS credentials or terraform.tfvars
4. **Public Access**: Blocked on S3 bucket
5. **HTTPS**: State file encryption in transit and at rest

## Troubleshooting

### Common Issues

**Issue**: "Error creating S3 bucket: BucketAlreadyExists"

- **Solution**: S3 bucket names must be globally unique. Change `backend_bucket_name` in terraform.tfvars

**Issue**: "Error launching instance: VPCIdNotSpecified"

- **Solution**: Ensure VPC is created first. Check dependency chain in main.tf

**Issue**: "Connection refused" when accessing web server

- **Solution**:
  - Verify Security Group allows HTTP from 0.0.0.0/0
  - Check instance state is "running"
  - Wait 2-3 minutes for user-data script to complete

**Issue**: "Error acquiring the state lock"

- **Solution**: Another process is using the state. Wait or manually remove lock from DynamoDB

## Screenshots Evidence

All required screenshots are stored in the `screenshots/` directory:

1. `terraform init` output
2. `terraform plan` output
3. `terraform apply` completion
4. Backend migration confirmation
5. EC2 instance in AWS Console
6. VPC resources in AWS Console
7. Security Group rules
8. S3 bucket with state file
9. DynamoDB table
10. Web server in browser
11. `terraform destroy` completion
