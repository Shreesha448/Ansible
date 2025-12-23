terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

variable "instance_id" {
  description = "EC2 instance ID to start"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

provider "aws" {
  region = var.region
}

resource "null_resource" "start_ec2_instance" {
  triggers = {
    always_start = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      echo '🟢 Starting EC2 instance: ${var.instance_id} in ${var.region}...'
      aws ec2 start-instances --instance-ids ${var.instance_id} --region ${var.region} --output table
      echo '⏳ Waiting for instance to start...'
      aws ec2 wait instance-running --instance-ids ${var.instance_id} --region ${var.region}
      echo '✅ EC2 instance ${var.instance_id} is now running!'
    EOT
    interpreter = ["PowerShell", "-Command"]
  }
}

# Fetch live details after start
data "aws_instance" "target" {
  instance_id = var.instance_id
  depends_on  = [null_resource.start_ec2_instance]
}

output "instance_id" {
  value       = var.instance_id
  description = "The started instance ID"
}

output "instance_public_ip" {
  value       = data.aws_instance.target.public_ip
  description = "The instance public IP after starting"
}

output "instance_private_ip" {
  value       = data.aws_instance.target.private_ip
  description = "The instance private IP after starting"
}

output "instance_state" {
  value       = data.aws_instance.target.instance_state
  description = "Current state of the instance"
}
