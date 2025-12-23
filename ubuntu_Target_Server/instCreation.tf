resource "aws_instance" "UbuntuInstance" {
  ami                    = "ami-0ecb62995f68bb549"
  instance_type          = "t3.micro"
  key_name               = "ubuntu-target-key"
  vpc_security_group_ids = [aws_security_group.ubuntu_sg.id]
  availability_zone      = var.zone

  tags = {
    Name    = "UbuntuInstance"
    project = "Terraform"
  }

}

# ---------------------------------
# OUTPUT FOR TARGET SERVER DETAILS
# ---------------------------------
output "ansible_target_details" {
  description = "Ansible target VM private IPs and SG ID"
  value = {
    target_1_private_ip = aws_instance.UbuntuInstance.private_ip
    #target_2_private_ip = aws_instance.ansible_target2.private_ip
    sg_id = aws_security_group.ubuntu_sg.id
  }
}

# Write the Target info into targetinfo.txt
resource "local_file" "ansible_target_file" {
  content = <<EOT
Ansible Target Information
--------------------------
Instance ID : ${aws_instance.UbuntuInstance.id}
Public IP   : ${aws_instance.UbuntuInstance.public_ip}
Private IP  : ${aws_instance.UbuntuInstance.private_ip}
SG ID       : ${aws_security_group.ubuntu_sg.id}
EOT

  filename = "${path.module}/targetinfo.txt"
}



