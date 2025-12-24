# ========================================
# Network Outputs
# ========================================

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

# ========================================
# Security Group Outputs
# ========================================

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.web_server.id
}

output "security_group_name" {
  description = "Name of the security group"
  value       = aws_security_group.web_server.name
}

# ========================================
# EC2 Instance Outputs
# ========================================

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.web_server.public_dns
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.web_server.private_ip
}

output "ami_id" {
  description = "AMI ID used for the instance"
  value       = data.aws_ami.amazon_linux_2.id
}

# ========================================
# Backend Outputs
# ========================================

output "s3_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.terraform_state.arn
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  value       = aws_dynamodb_table.terraform_lock.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.terraform_lock.arn
}

# ========================================
# Connection Information
# ========================================

output "ssh_connection_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i your-key.pem ec2-user@${aws_instance.web_server.public_ip}"
}

output "web_url" {
  description = "URL to access the web server"
  value       = "http://${aws_instance.web_server.public_ip}"
}

# ========================================
# Summary Output
# ========================================

output "deployment_summary" {
  description = "Summary of deployed resources"
  value = {
    region         = var.aws_region
    vpc_id         = aws_vpc.main.id
    subnet_id      = aws_subnet.public.id
    instance_id    = aws_instance.web_server.id
    public_ip      = aws_instance.web_server.public_ip
    web_url        = "http://${aws_instance.web_server.public_ip}"
    s3_bucket      = aws_s3_bucket.terraform_state.id
    dynamodb_table = aws_dynamodb_table.terraform_lock.name
  }
}
