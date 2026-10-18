# 버전은 호출하는 쪽(tfvars)에서 고정한다. 자동으로 최신 버전을 고르지 않는다.
# 클러스터 생성 시 기본 설치된(self-managed) vpc-cni, kube-proxy, coredns를 관리형 애드온으로 가져온다
resource "aws_eks_addon" "this" {
  for_each = var.addons

  cluster_name                = var.cluster_name
  addon_name                  = each.key
  addon_version               = each.value.version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}
