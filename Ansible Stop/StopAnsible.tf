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
  description = "EC2 instance ID to stop"
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

resource "null_resource" "stop_ec2_instance" {
  triggers = {
    always_stop = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      echo '🟠 Stopping EC2 instance: ${var.instance_id} in ${var.region}...'
      aws ec2 stop-instances --instance-ids ${var.instance_id} --region ${var.region} --output table
      echo '⏳ Waiting for instance to stop...'
      aws ec2 wait instance-stopped --instance-ids ${var.instance_id} --region ${var.region}
      echo '✅ EC2 instance ${var.instance_id} is now stopped!'
    EOT
    interpreter = ["PowerShell", "-Command"]
  }
}

# Fetch instance info after stop
data "aws_instance" "target" {
  instance_id = var.instance_id
  depends_on  = [null_resource.stop_ec2_instance]
}

output "instance_id" {
  value       = var.instance_id
  description = "The stopped instance ID"
}

output "instance_state" {
  value       = data.aws_instance.target.instance_state
  description = "The current state of the instance"
}

output "instance_public_ip" {
  value       = data.aws_instance.target.public_ip
  description = "The instance's public IP (may be null when stopped)"
}
