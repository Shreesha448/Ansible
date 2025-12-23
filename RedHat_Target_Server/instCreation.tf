# -------------------------------------------------------------
# RedHat EC2 Instance 1 (Original)
# -------------------------------------------------------------
# This block launches your first RedHat EC2 target VM.
# No changes made here — this remains as your original instance.
resource "aws_instance" "RedHatInstance" {
  ami                    = var.amiID[var.region]
  instance_type          = "t3.micro"
  key_name               = "red-target-key"
  vpc_security_group_ids = [aws_security_group.RedHat_sg.id]
  availability_zone      = var.zone

  tags = {
    Name    = "RedHatInstance"
    project = "Terraform"
  }
}

# -------------------------------------------------------------
# UPDATED OUTPUT 
# -------------------------------------------------------------
# Changed the output name to "red_target2_details" to match
# the new resource ("RedHatInstance2").
# Now Terraform will output details for the SECOND instance.
output "red_target2_details" {
  description = "Second RedHat target VM private IPs and SG ID"
  value = {
    target_2_private_ip = aws_instance.RedHatInstance2.private_ip
    sg_id               = aws_security_group.RedHat_sg.id
  }
}

# -------------------------------------------------------------
# NEW ADDITION 
# -------------------------------------------------------------
# Added a separate local file resource to store information
# about the SECOND RedHat VM.
# This helps keep both instance outputs documented.
resource "local_file" "red_target_file2" {
  content = <<EOT
RedHat Target 2 Information
----------------------------
Instance ID : ${aws_instance.RedHatInstance2.id}
Public IP   : ${aws_instance.RedHatInstance2.public_ip}
Private IP  : ${aws_instance.RedHatInstance2.private_ip}
SG ID       : ${aws_security_group.RedHat_sg.id}
EOT

  filename = "${path.module}/red-targetinfo2.txt" # New file for the second VM
}
