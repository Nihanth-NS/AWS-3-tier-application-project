resource "helm_release" "aws_load_balancer_controller" {
  depends_on = [ aws_eks_addon.ebs_csi,
    kubernetes_service_account_v1.alb_controller]
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace = "kube-system"
  set = [
  {
    name  = "clusterName"
    value = aws_eks_cluster.cluster.name
  },
  {
    name  = "region"
    value = "us-east-1"
  },
  {
    name  = "vpcId"
    value = aws_vpc.main.id
  },
  {
    name  = "serviceAccount.create"
    value = "false"
  },
  {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
  ]
}
resource "helm_release" "argocd" {
  depends_on = [ helm_release.aws_load_balancer_controller ]
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  namespace        = "argocd"
  create_namespace = true
}
