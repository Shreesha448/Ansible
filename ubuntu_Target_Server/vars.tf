variable "region" {
  type    = string
  default = "us-east-1"
}

variable "zone" {
  type    = string
  default = "us-east-1a"
}

variable "web_user" {
  type    = string
  default = "ubuntu"
}

variable "amiID" {
  type = map(string)
  default = {
    us-east-1 = "ami-0cae6d6fe6048ca2c"
    us-east-2 = "ami-05803413c51f242b7"
  }
}
