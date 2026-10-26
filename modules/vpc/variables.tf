variable "name" {
  type        = string
  description = "리소스 이름 접두사 (예: hbilling-dev)"
}

variable "cluster_name" {
  type        = string
  description = "서브넷에 kubernetes.io/cluster/<name> 태그를 붙일 EKS 클러스터 이름"
}

variable "cidr" {
  type        = string
  description = "VPC CIDR 블록"

  validation {
    condition     = can(cidrnetmask(var.cidr))
    error_message = "cidr는 유효한 IPv4 CIDR이어야 합니다."
  }
}

variable "azs" {
  type        = list(string)
  description = "사용할 가용 영역 목록"

  validation {
    condition     = length(var.azs) >= 2
    error_message = "EKS는 최소 2개의 가용 영역이 필요합니다."
  }
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "AZ 순서와 동일한 public 서브넷 CIDR 목록"

  validation {
    condition     = length(var.public_subnet_cidrs) == length(var.azs)
    error_message = "public_subnet_cidrs 개수는 azs 개수와 같아야 합니다."
  }
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "AZ 순서와 동일한 private 서브넷 CIDR 목록 (노드·파드 IP 대역)"

  validation {
    condition     = length(var.private_subnet_cidrs) == length(var.azs)
    error_message = "private_subnet_cidrs 개수는 azs 개수와 같아야 합니다."
  }
}

variable "single_nat_gateway" {
  type        = bool
  description = "true면 NAT Gateway를 첫 번째 AZ에 1개만 생성 (비용 절감), false면 AZ마다 생성 (고가용성)"
  default     = true
}
