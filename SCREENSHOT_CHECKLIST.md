# Screenshot Checklist

## Required Screenshots for Submission

### 1. Terraform Commands

- [ ] **01-terraform-init.png**: Output of `terraform init` showing successful initialization
- [ ] **02-terraform-plan.png**: Output of `terraform plan` showing all resources to be created
- [ ] **03-terraform-apply.png**: Output of `terraform apply` showing successful deployment with outputs
- [ ] **04-backend-migration.png**: Output of `terraform init -migrate-state` confirming state migration

### 2. AWS Console - Resources

- [ ] **05-ec2-console.png**: EC2 Instances dashboard showing running instance with details
- [ ] **06-vpc-console.png**: VPC dashboard showing created VPC, subnet, and IGW
- [ ] **07-security-group.png**: Security Group showing inbound and outbound rules

### 3. AWS Console - Backend

- [ ] **08-s3-bucket.png**: S3 bucket showing:
  - terraform.tfstate file
  - Versioning enabled
  - Encryption enabled
  - Public access blocked
- [ ] **09-dynamodb-table.png**: DynamoDB table showing terraform-state-lock table details

### 4. Verification

- [ ] **10-web-browser.png**: Browser showing the web page served by EC2 instance
- [ ] **11-terraform-destroy.png**: Output of `terraform destroy` showing successful cleanup

## What to Capture in Each Screenshot

### 01-terraform-init.png

```
✓ "Initializing the backend..."
✓ "Initializing provider plugins..."
✓ "Terraform has been successfully initialized!"
```

### 02-terraform-plan.png

```
✓ Plan showing: X to add, 0 to change, 0 to destroy
✓ List of resources to be created
✓ Resource count (should be ~13 resources)
```

### 03-terraform-apply.png

```
✓ "Apply complete! Resources: X added, 0 changed, 0 destroyed"
✓ Outputs section showing:
  - instance_public_ip
  - vpc_id
  - s3_bucket_name
  - dynamodb_table_name
  - web_url
  - deployment_summary
```

### 04-backend-migration.png

```
✓ "Do you want to copy existing state to the new backend?"
✓ Your "yes" response
✓ "Successfully configured the backend 's3'!"
✓ Migration completion message
```

### 05-ec2-console.png

Must show:

- ✓ Instance ID
- ✓ Instance state (running)
- ✓ Instance type (t2.micro)
- ✓ Public IPv4 address
- ✓ Availability Zone
- ✓ VPC ID
- ✓ Tags (Name: terraform-iac-project-web-server)

### 06-vpc-console.png

Must show:

- ✓ VPC with CIDR 10.0.0.0/16
- ✓ Public subnet with CIDR 10.0.1.0/24
- ✓ Internet Gateway (attached)
- ✓ Route table with route to 0.0.0.0/0
- ✓ Tags matching project name

### 07-security-group.png

Must show:

- ✓ Security group name
- ✓ Inbound rules:
  - SSH (22) from your specific IP/32
  - HTTP (80) from 0.0.0.0/0
- ✓ Outbound rules:
  - All traffic to 0.0.0.0/0

### 08-s3-bucket.png

Capture multiple views or one comprehensive view showing:

- ✓ Bucket name matching your configuration
- ✓ Objects tab showing terraform.tfstate file
- ✓ Properties tab showing "Versioning: Enabled"
- ✓ Properties tab showing "Default encryption: Enabled"
- ✓ Permissions tab showing "Block all public access: On"
- ✓ Tags showing project metadata

### 09-dynamodb-table.png

Must show:

- ✓ Table name: terraform-state-lock
- ✓ Table status: Active
- ✓ Partition key: LockID (String)
- ✓ Read/write capacity mode: On-demand
- ✓ Tags showing project metadata

### 10-web-browser.png

Must show:

- ✓ URL bar with http://<public-ip>
- ✓ Page content: "Hello from Terraform!"
- ✓ Instance ID displayed on page
- ✓ Availability Zone displayed on page

### 11-terraform-destroy.png

```
✓ Destroy plan showing resources to be destroyed
✓ "Destroy complete! Resources: X destroyed"
✓ Clean completion with no errors
```

## Pro Tips for Screenshots

1. **Use full screen** or maximize windows for clarity
2. **Include timestamps** where visible
3. **Highlight important information** (optional, using annotations)
4. **Use high resolution** - text should be readable
5. **Capture entire terminal output** when relevant
6. **Name files consistently** as specified above
7. **Verify all details are visible** before submission

## Screenshot Organization

Save all screenshots in the `screenshots/` directory:

```
screenshots/
├── 01-terraform-init.png
├── 02-terraform-plan.png
├── 03-terraform-apply.png
├── 04-backend-migration.png
├── 05-ec2-console.png
├── 06-vpc-console.png
├── 07-security-group.png
├── 08-s3-bucket.png
├── 09-dynamodb-table.png
├── 10-web-browser.png
└── 11-terraform-destroy.png
```

## Verification Before Submission

- [ ] All 11 screenshots captured
- [ ] All screenshots are clear and readable
- [ ] Screenshots show successful operations
- [ ] File names match the checklist
- [ ] Screenshots are in PNG or JPG format
- [ ] All critical information is visible in each screenshot
