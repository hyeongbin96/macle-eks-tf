# state 버킷 자체를 만드는 단계이므로 로컬 state를 사용한다
terraform {
  required_version = ">= 1.10, < 2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
