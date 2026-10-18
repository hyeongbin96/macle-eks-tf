variable "cluster_name" {
  type        = string
  description = "노드 그룹을 붙일 EKS 클러스터 이름"
}

variable "kubernetes_version" {
  type        = string
  description = "노드 Kubernetes 버전 (컨트롤 플레인과 동일하게 유지)"
}

variable "subnet_ids" {
  type        = list(string)
  description = "노드를 배치할 서브넷 ID 목록 (private 서브넷)"
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
  description = "노드 그룹 정의. 키가 노드 그룹 이름 접미사가 된다. release_version을 비우면 생성 시점의 최신 AMI를 사용한다."

  validation {
    condition     = alltrue([for ng in values(var.node_groups) : ng.min_size <= ng.desired_size && ng.desired_size <= ng.max_size])
    error_message = "각 노드 그룹은 min_size <= desired_size <= max_size 를 만족해야 합니다."
  }

  validation {
    condition     = alltrue([for ng in values(var.node_groups) : contains(["ON_DEMAND", "SPOT"], ng.capacity_type)])
    error_message = "capacity_type은 ON_DEMAND 또는 SPOT이어야 합니다."
  }
}
