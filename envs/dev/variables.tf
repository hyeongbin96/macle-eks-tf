variable "region" {
  type        = string
  description = "AWS 리전"
}

variable "project" {
  type        = string
  description = "프로젝트 이름 (리소스 이름 접두사)"
}

variable "environment" {
  type        = string
  description = "환경 이름"

  validation {
    condition     = contains(["dev", "stg", "prod"], var.environment)
    error_message = "environment는 dev, stg, prod 중 하나여야 합니다."
  }
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR 블록"
}

variable "azs" {
  type        = list(string)
  description = "사용할 가용 영역"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "AZ 순서의 public 서브넷 CIDR"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "AZ 순서의 private 서브넷 CIDR"
}

variable "single_nat_gateway" {
  type        = bool
  description = "NAT Gateway를 1개만 생성할지 여부"
  default     = true
}

variable "kubernetes_version" {
  type        = string
  description = "EKS Kubernetes 버전"
}

variable "public_access_cidrs" {
  type        = list(string)
  description = "EKS Public API 엔드포인트 접근 허용 CIDR"
}

variable "admin_principal_arns" {
  type        = list(string)
  description = "클러스터 관리자 권한을 줄 IAM 사용자/역할 ARN (클러스터 생성자 제외)"
  default     = []
}

variable "cluster_log_retention_days" {
  type        = number
  description = "컨트롤 플레인 로그 보존 기간(일)"
  default     = 30
}

variable "cluster_support_type" {
  type        = string
  description = "EKS 업그레이드 정책. EXTENDED는 표준 지원 종료 후 12개월간 자동 업그레이드를 미룸 (그 기간은 추가 요금)"
  default     = "EXTENDED"
}

variable "node_groups" {
  type = map(object({
    instance_types  = list(string)
    capacity_type   = optional(string, "ON_DEMAND")
    ami_type        = optional(string, "AL2023_x86_64_STANDARD")
    release_version = optional(string)
    desired_size    = number
    min_size        = number
    max_size        = number
    disk_size       = optional(number, 30)
    labels          = optional(map(string), {})
  }))
  description = "관리형 노드 그룹 정의"
}

variable "addons" {
  type = map(object({
    version = string
  }))
  description = "EKS 관리형 애드온과 고정 버전"
}
