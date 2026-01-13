#!/usr/bin/env bash
# Create S3 backend and DynamoDB lock table (eu-west-1)
set -euo pipefail

AWS_REGION="eu-west-1"
BUCKET="terraform-state-huey-20240101"
TABLE="terraform-state-lock"

# verify credentials
aws sts get-caller-identity

# create S3 bucket if missing
if ! aws s3api head-bucket --bucket "$BUCKET" --region "$AWS_REGION" 2>/dev/null; then
  echo "Creating bucket $BUCKET in $AWS_REGION..."
  aws s3api create-bucket \
    --bucket "$BUCKET" \
    --region "$AWS_REGION" \
    --create-bucket-configuration LocationConstraint="$AWS_REGION"
  aws s3api put-bucket-versioning \
    --bucket "$BUCKET" \
    --versioning-configuration Status=Enabled
  aws s3api put-public-access-block \
    --bucket "$BUCKET" \
    --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
  aws s3api put-bucket-encryption \
    --bucket "$BUCKET" \
    --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
  echo "Bucket created and configured."
else
  echo "Bucket $BUCKET already exists."
fi

# create DynamoDB table if missing
if ! aws dynamodb describe-table --table-name "$TABLE" --region "$AWS_REGION" >/dev/null 2>&1; then
  echo "Creating DynamoDB table $TABLE..."
  aws dynamodb create-table \
    --table-name "$TABLE" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region "$AWS_REGION"
else
  echo "DynamoDB table $TABLE already exists (or being created)."
fi

# wait for table ACTIVE
echo "Waiting for DynamoDB table to become ACTIVE..."
until [ "$(aws dynamodb describe-table --table-name "$TABLE" --query 'Table.TableStatus' --output text --region "$AWS_REGION" 2>/dev/null)" = "ACTIVE" ]; do
  sleep 3
done
echo "DynamoDB table is ACTIVE. Backend ready."