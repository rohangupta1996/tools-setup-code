terraform {
  backend "s3" {
    bucket = "rohan2025bucket"
    key = "module-infra/state"
    region = "us-east-1"}
}

variable "ami_id" {
  default = "ami-09c813fb71547fc4f"
}

variable "zone_id" {
  default = "Z062606912JIR9B1U53PA"
}

variable "tools" {
  default = {
    vault = {
      instance_type = "t2.micro"
      port = 8200
    }
  }

}

module "tool-infra" {
  source = "./module-infra"
  for_each = var.tools

  ami_id = var.ami_id
  instance_type = each.value["instance_type"]
  name = each.key
  port = each.value["port"]
  zone_id = var.zone_id
}