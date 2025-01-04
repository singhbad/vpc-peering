aws_region = "us-east-1"

vpc_cidrs = {
  db   = "10.0.0.0/16"
  web  = "10.1.0.0/16"
  app  = "10.2.0.0/16"
}

availability_zones = {
  db  = "us-east-1a"
  web = "us-east-1b"
  app = "us-east-1b"
}

instance_type = "t2.micro"
enable_public_ip = true