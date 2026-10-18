variable "cluster_name" {
  type        = string
  description = "애드온을 설치할 EKS 클러스터 이름"
}

variable "addons" {
  type = map(object({
    version = string
  }))
  description = "설치할 EKS 관리형 애드온과 고정 버전. 키는 애드온 이름 (예: vpc-cni)"

  validation {
    condition     = alltrue([for a in values(var.addons) : can(regex("^v[0-9]+\\.[0-9]+\\.[0-9]+-eksbuild\\.[0-9]+$", a.version))])
    error_message = "애드온 버전은 vX.Y.Z-eksbuild.N 형식이어야 합니다 (예: v1.23.1-eksbuild.1)."
  }
}
