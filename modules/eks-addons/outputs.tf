output "addon_versions" {
  description = "설치된 애드온별 버전"
  value       = { for k, a in aws_eks_addon.this : k => a.addon_version }
}
