variable "region" {
  type        = string
  description = "state 버킷을 만들 AWS 리전"
}

variable "project" {
  type        = string
  description = "프로젝트 이름. 버킷 이름은 <project>-tfstate-<account_id>가 된다."
}

variable "noncurrent_version_retention_days" {
  type        = number
  description = "이전 버전 state 파일 보존 기간(일)"
  default     = 90
}
