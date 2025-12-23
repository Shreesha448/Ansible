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
    us-east-1 = "ami-069e612f612be3a2b"
    us-east-2 = "ami-05803413c51f242b7"
  }
}
