resource "aws_security_group" "ans_sg" {
  name        = "ans_sg"
  description = "sample security group to try terraform"
  tags = {
    Name = "ans_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "SSHfromMyIP" {
  security_group_id = aws_security_group.ans_sg.id
  cidr_ipv4         = "106.51.72.216/32"
  from_port         = 22
  ip_protocol       = "TCP"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_Outbound_ipv4" {
  security_group_id = aws_security_group.ans_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_Outbound_ipv6" {
  security_group_id = aws_security_group.ans_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
