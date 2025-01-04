terraform {
  backend "s3" {
    bucket = "singhbad"
    key    = "terraform/state/terraform.tfstate"
    region = "us-east-1"
  }
}