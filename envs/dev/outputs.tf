output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "private 서브넷 ID 목록"
  value       = module.vpc.private_subnet_ids
}

output "nat_public_ips" {
  description = "NAT Gateway 공인 IP (외부 서비스 화이트리스트용)"
  value       = module.vpc.nat_public_ips
}

output "cluster_name" {
  description = "EKS 클러스터 이름"
  value       = module.eks_cluster.cluster_name
}

output "cluster_endpoint" {
  description = "Kubernetes API 엔드포인트"
  value       = module.eks_cluster.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "EKS 클러스터 보안 그룹 ID"
  value       = module.eks_cluster.cluster_security_group_id
}

output "oidc_provider_arn" {
  description = "IRSA용 OIDC Provider ARN"
  value       = module.eks_cluster.oidc_provider_arn
}

output "node_groups" {
  description = "노드 그룹별 이름과 ARN"
  value       = module.eks_node_group.node_groups
}

output "addon_versions" {
  description = "설치된 애드온 버전"
  value       = module.eks_addons.addon_versions
}

output "configure_kubectl" {
  description = "kubeconfig 설정 명령"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks_cluster.cluster_name}"
}
