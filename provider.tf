provider "aws" {
  version = "~> 2.0"
  region = "${var.region}"
  access_key = "${var.aws-key}"
  secret_key = "${var.aws-token}"
}

#It is recommended to Add the tf state to a S3 bucket with the backend solution for terraform, but to avoid someone else the creation of a bucket for it I will live it commented

# terraform {
#   backend "s3" {
#     bucket = "bucketname"
#     key    = "pathkey"
#     region = "us-east-1"
#   }
# }