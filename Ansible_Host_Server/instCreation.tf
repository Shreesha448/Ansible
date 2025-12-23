resource "aws_instance" "AnsibleInstance" {
  ami                    = "ami-0cae6d6fe6048ca2c"
  instance_type          = "t3.micro"
  key_name               = "ansible-key"
  vpc_security_group_ids = [aws_security_group.ans_sg.id]
  availability_zone      = "us-east-1a"

  tags = {
    Name    = "AnsibleInstance"
    project = "Terraform"
  }
}

# ---------------------------------
# OUTPUT FOR ANSIBLE MASTER DETAILS
# ---------------------------------
output "ansible_master_details" {
  description = "Ansible master instance ID, public/private IP and SG ID"
  value = {
    instance_id = aws_instance.AnsibleInstance.id
    public_ip   = aws_instance.AnsibleInstance.public_ip
    private_ip  = aws_instance.AnsibleInstance.private_ip
    sg_id       = aws_security_group.ans_sg.id
  }
}

# Write the Ansible master info into ansibleinfo.txt
resource "local_file" "ansible_master_file" {
  content = <<EOT
Ansible Master Information
--------------------------
Instance ID : ${aws_instance.AnsibleInstance.id}
Public IP   : ${aws_instance.AnsibleInstance.public_ip}
Private IP  : ${aws_instance.AnsibleInstance.private_ip}
SG ID       : ${aws_security_group.ans_sg.id}
EOT

  filename = "${path.module}/ansibleinfo.txt"
}
