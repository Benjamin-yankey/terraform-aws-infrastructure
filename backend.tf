# ========================================
# Remote Backend Configuration
# ========================================
# 
# IMPORTANT: This file will be uncommented and configured AFTER
# the initial deployment creates the S3 bucket and DynamoDB table.
#
# Initial deployment steps:
# 1. Keep this file commented out
# 2. Run: terraform init, plan, apply
# 3. After S3 and DynamoDB are created, uncomment this block
# 4. Run: terraform init -migrate-state
# 5. Confirm the migration when prompted
#
# ========================================

# Uncomment after initial deployment:

terraform {
  backend "s3" {
    bucket         = "terraform-state-huey-20240101"
    key            = "global/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-lock" # lock table name
    encrypt        = true
    # use_lockfile = true    # optional/newer param; uncomment if desired per TF docs
  }
}
