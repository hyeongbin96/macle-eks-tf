module "vpc" {
  source = "../../modules/vpc"

  name                 = local.name_prefix
  cluster_name         = local.cluster_name
  cidr                 = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  single_nat_gateway   = var.single_nat_gateway
}

module "eks_cluster" {
  source = "../../modules/eks-cluster"

  cluster_name         = local.cluster_name
  kubernetes_version   = var.kubernetes_version
  subnet_ids           = module.vpc.private_subnet_ids
  public_access_cidrs  = var.public_access_cidrs
  admin_principal_arns = var.admin_principal_arns
  log_retention_days   = var.cluster_log_retention_days
  support_type         = var.cluster_support_type
}

module "eks_node_group" {
  source = "../../modules/eks-node-group"

  cluster_name       = module.eks_cluster.cluster_name
  kubernetes_version = module.eks_cluster.cluster_version
  subnet_ids         = module.vpc.private_subnet_ids
  node_groups        = var.node_groups
}

module "eks_addons" {
  source = "../../modules/eks-addons"

  cluster_name = module.eks_cluster.cluster_name
  addons       = var.addons

  # coredns는 노드가 있어야 Active가 되므로 노드 그룹 이후에 설치한다
  depends_on = [module.eks_node_group]
}
