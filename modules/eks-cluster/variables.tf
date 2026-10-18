variable "cluster_name" {
  type        = string
  description = "EKS 클러스터 이름"
}

variable "kubernetes_version" {
  type        = string
  description = "EKS Kubernetes 버전 (예: 1.37)"
}

variable "subnet_ids" {
  type        = list(string)
  description = "컨트롤 플레인 ENI를 배치할 서브넷 ID 목록 (private 서브넷 권장)"
}

variable "public_access_cidrs" {
  type        = list(string)
  description = "Public API 엔드포인트에 접근을 허용할 CIDR 목록"

  validation {
    condition     = length(var.public_access_cidrs) > 0 && alltrue([for c in var.public_access_cidrs : can(cidrnetmask(c)) && c != "0.0.0.0/0"])
    error_message = "public_access_cidrs는 1개 이상의 유효한 CIDR이어야 하며 0.0.0.0/0은 허용하지 않습니다."
  }
}

variable "admin_principal_arns" {
  type        = list(string)
  description = "클러스터 관리자(AmazonEKSClusterAdminPolicy) 권한을 줄 IAM 사용자/역할 ARN 목록. 클러스터 생성자는 포함하지 않는다."
  default     = []
}

variable "bootstrap_cluster_creator_admin_permissions" {
  type        = bool
  description = "클러스터를 생성한 IAM 주체에게 관리자 Access Entry를 자동 부여할지 여부 (변경 시 클러스터 재생성)"
  default     = true
}

variable "enabled_log_types" {
  type        = list(string)
  description = "활성화할 컨트롤 플레인 로그 유형"
  default     = ["api", "audit", "authenticator"]
}

variable "log_retention_days" {
  type        = number
  description = "컨트롤 플레인 로그 보존 기간(일)"
  default     = 30
}

variable "kms_deletion_window_in_days" {
  type        = number
  description = "Secret 암호화 KMS 키 삭제 대기 기간(일)"
  default     = 7

  validation {
    condition     = var.kms_deletion_window_in_days >= 7 && var.kms_deletion_window_in_days <= 30
    error_message = "kms_deletion_window_in_days는 7~30 사이여야 합니다."
  }
}

variable "support_type" {
  type        = string
  description = "업그레이드 정책. STANDARD는 표준 지원 종료 시 자동 업그레이드, EXTENDED는 추가 비용으로 연장 지원"
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "EXTENDED"], var.support_type)
    error_message = "support_type은 STANDARD 또는 EXTENDED여야 합니다."
  }
}
