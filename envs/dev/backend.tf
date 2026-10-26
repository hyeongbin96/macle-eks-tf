# bucket 값의 ACCOUNT_ID를 bootstrap의 state_bucket_name 출력값으로 바꾼 뒤 terraform init 한다
terraform {
  backend "s3" {
    bucket       = "hbilling-tfstate-913210543372"
    key          = "envs/dev/terraform.tfstate"
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true
  }
}