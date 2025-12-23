resource "aws_instance" "DBInstance" {
  ami                    = "ami-0cae6d6fe6048ca2c"
  instance_type          = "t3.micro"
  key_name               = "DB-key"
  vpc_security_group_ids = [aws_security_group.DB_sg.id]
  availability_zone      = var.zone

  tags = {
    Name    = "DBInstance"
    project = "Terraform"
  }

}

# ---------------------------------
# OUTPUT FOR TARGET SERVER DETAILS
# ---------------------------------
output "DB_Server_details" {
  description = "DB Server VM private IPs and SG ID"
  value = {
    target_1_private_ip = aws_instance.DBInstance.private_ip
    #target_2_private_ip = aws_instance.ansible_target2.private_ip
    sg_id = aws_security_group.DB_sg.id
  }
}

# Write the Target info into targetinfo.txt
resource "local_file" "DB_Server_info_file" {
  content = <<EOT
DB Server Information
--------------------------
Instance ID : ${aws_instance.DBInstance.id}
Public IP   : ${aws_instance.DBInstance.public_ip}
Private IP  : ${aws_instance.DBInstance.private_ip}
SG ID       : ${aws_security_group.DB_sg.id}
EOT

  filename = "${path.module}/DB_Server_info.txt"
}



