resource "aws_iam_role" "clus_role" {
  name = "cluster_Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "cluster_policy_1" {
  role       = aws_iam_role.clus_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"
}
resource "aws_iam_role_policy_attachment" "cluster_policy_2" {
  role       = aws_iam_role.clus_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
resource "aws_iam_role_policy_attachment" "cluster_policy_3" {
  role       = aws_iam_role.clus_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSComputePolicy"
}
resource "aws_iam_role_policy_attachment" "cluster_policy_4" {
  role       = aws_iam_role.clus_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
}
resource "aws_iam_role_policy_attachment" "cluster_policy_5" {
  role       = aws_iam_role.clus_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
}
resource "aws_iam_role_policy_attachment" "cluster_policy_6" {
  role       = aws_iam_role.clus_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicyV2"
}

resource "aws_iam_role" "node_role" {
  name = "Node_Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "node_policy_1" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}
resource "aws_iam_role_policy_attachment" "node_policy_2" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy"
}
resource "aws_iam_role_policy_attachment" "node_policy_3" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
resource "aws_iam_role_policy_attachment" "node_policy_4" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
resource "aws_iam_role" "lb_role" {
  name = "LB_Role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
          Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
     StringEquals = {
    format(
      "%s:sub",
      replace(
        data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer,
        "https://",
        ""
      )
    ) = "system:serviceaccount:kube-system:aws-load-balancer-controller"
  }
}
        }
    ]
  })
}
resource "aws_iam_policy" "alb_policy" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("lb_iam_policy.json")
}
resource "aws_iam_role_policy_attachment" "lb_policy_1" {
  role       = aws_iam_role.lb_role.name
  policy_arn = aws_iam_policy.alb_policy.arn
}
resource "aws_iam_role" "ebs_csi_role" {
  name = "AmazonEKS_EBS_CSI_DriverRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Federated = aws_iam_openid_connect_provider.eks.arn
      }

      Action = "sts:AssumeRoleWithWebIdentity"

      Condition = {
        StringEquals = {
    format(
      "%s:sub",
      replace(
        data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer,
        "https://",
        ""
      )
    ) = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
  }
      }
    }]
  })
}
resource "aws_iam_role_policy_attachment" "ebs_csi_policy" {
  role       = aws_iam_role.ebs_csi_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
