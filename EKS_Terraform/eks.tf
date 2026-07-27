resource "aws_eks_cluster" "cluster" {
  depends_on = [
  aws_iam_role_policy_attachment.cluster_policy_1,
  aws_iam_role_policy_attachment.cluster_policy_2,
  aws_iam_role_policy_attachment.cluster_policy_3,
  aws_iam_role_policy_attachment.cluster_policy_4,
  aws_iam_role_policy_attachment.cluster_policy_5,
  aws_iam_role_policy_attachment.cluster_policy_6,
  aws_iam_role_policy_attachment.node_policy_1,
  aws_iam_role_policy_attachment.node_policy_2,
  aws_iam_role_policy_attachment.node_policy_3,
  aws_iam_role_policy_attachment.node_policy_4
]
  name = "example-abc"
  role_arn = aws_iam_role.clus_role.arn
  bootstrap_self_managed_addons = false
  access_config {
    authentication_mode = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }
  compute_config {
    enabled = true
    node_role_arn = aws_iam_role.node_role.arn
    node_pools = [ "general-purpose", "system" ]
  }
  kubernetes_network_config {
    elastic_load_balancing {
      enabled = true
    }
  }
  storage_config {
    block_storage {
      enabled = true
    }
  }
  version  = "1.35"
  vpc_config {
    subnet_ids = [
      aws_subnet.main3.id,
      aws_subnet.main4.id,
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  
}
data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.cluster.name
}
data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.cluster.name
}
data "tls_certificate" "eks" {
  depends_on = [ aws_eks_cluster.cluster ]
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}
resource "aws_iam_openid_connect_provider" "eks" {
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.eks.certificates[0].sha1_fingerprint
  ]
}
resource "kubernetes_service_account_v1" "alb_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.lb_role.arn
    }
  }
}
resource "aws_eks_addon" "ebs_csi" {
  cluster_name             = aws_eks_cluster.cluster.name
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = aws_iam_role.ebs_csi_role.arn
  depends_on = [
    aws_iam_role_policy_attachment.ebs_csi_policy
  ]
}
