variable "region" {
  type = "string"
}

variable "aws-key" {
  description = "Please type your AWS Key"
  type = "string"
}

variable "aws-token" {
  description = "Please type your AWS Token"
  type = "string"
}

variable "solution_name" {
  description = "name of the solution or app that you are working on"
  type        = "string"
}
variable "azs" {
  type = "list"
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "ec2_amis" {
  description = "Ubuntu Server 16.04 LTS (HVM)"
  type        = "map"

  default = {
    "us-east-1" = "ami-059eeca93cf09eebd"
  }
}