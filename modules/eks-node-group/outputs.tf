output "node_role_arn" {
  description = "노드 IAM 역할 ARN"
  value       = aws_iam_role.node.arn
}

output "node_groups" {
  description = "노드 그룹별 이름과 ARN"
  value = {
    for k, ng in aws_eks_node_group.this : k => {
      name = ng.node_group_name
      arn  = ng.arn
    }
  }
}
