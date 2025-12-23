resource "aws_security_group" "DB_sg" {
  name        = "DB_sg"
  description = "sample security group to try terraform"
  tags = {
    Name = "DB_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "SSHfromMyIP" {
  security_group_id = aws_security_group.DB_sg.id
  cidr_ipv4         = "106.51.72.216/32"
  from_port         = 22
  ip_protocol       = "TCP"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_HTTP" {
  security_group_id             = aws_security_group.DB_sg.id
  referenced_security_group_id  = "sg-06234b8264d03cbec"  # <-- Allow traffic from this SG
  from_port                     = 0
  to_port                       = 65535                   # Full TCP range
  ip_protocol                   = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "allow_all_Outbound_ipv4" {
  security_group_id = aws_security_group.DB_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_Outbound_ipv6" {
  security_group_id = aws_security_group.DB_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
