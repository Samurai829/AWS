/*
Aqui colocas la version de terraform que usaras y 
para que proveedor se estaria usando
*/
terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
      }
    }
  required_version = ">= 0.13"
}

provider "aws" {
  region     = "us-west-2"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
}