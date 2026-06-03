# Phase 9 AWS EKS Cluster Evidence

Date: Wed Jun  3 08:50:48 BST 2026

## AWS Account
{
    "UserId": "AIDAZ3MGNMDLNUHDXEGQS",
    "Account": "677276115158",
    "Arn": "arn:aws:iam::677276115158:user/clintrial-admin"
}

## EKS Cluster
------------------------------------------------------------------------------------------
|                                     DescribeCluster                                    |
+----------+-----------------------------------------------------------------------------+
|  endpoint|  https://674F83E05EEE8BE55B878DA06AA2F636.yl4.us-east-1.eks.amazonaws.com   |
|  name    |  shopswift-bluegreen-eks                                                    |
|  status  |  ACTIVE                                                                     |
|  version |  1.30                                                                       |
+----------+-----------------------------------------------------------------------------+

## Kubernetes Context
arn:aws:eks:us-east-1:677276115158:cluster/shopswift-bluegreen-eks

## Nodes
NAME                            STATUS   ROLES    AGE     VERSION                INTERNAL-IP     EXTERNAL-IP      OS-IMAGE                        KERNEL-VERSION                    CONTAINER-RUNTIME
ip-192-168-34-80.ec2.internal   Ready    <none>   2m8s    v1.30.14-eks-3385e9b   192.168.34.80   100.55.100.187   Amazon Linux 2023.11.20260526   6.1.172-216.329.amzn2023.x86_64   containerd://2.2.3+unknown
ip-192-168-7-185.ec2.internal   Ready    <none>   2m12s   v1.30.14-eks-3385e9b   192.168.7.185   98.93.44.42      Amazon Linux 2023.11.20260526   6.1.172-216.329.amzn2023.x86_64   containerd://2.2.3+unknown

## ECR Images
-------------------------------------------------------------------------------------------
|                                       ListImages                                        |
+-----------------------------------------------------------------------------------------+
||                                       imageIds                                        ||
|+---------------------------------------------------------------------------+-----------+|
||                                imageDigest                                | imageTag  ||
|+---------------------------------------------------------------------------+-----------+|
||  sha256:c39e67b716cf8ce8a8ce4661d586c47cb517c1620c168995d7ba449f30ad4206  |           ||
||  sha256:29106ad0d3c33389669fe7b12aa2fed09549667987fb39299512b43c692f0b90  |           ||
||  sha256:9b149a52d232d96d0e3940349d79fc83f20464c43626071be087a1d88f554520  |           ||
||  sha256:69920121b1d19251f8da004ea73874093650f8d9cd91cf646d63eb84dc0372ae  |  v2.0.0   ||
||  sha256:17eff95ceaa0c6de12d0cfa65906c7c52fc45f0a7d6bcb7e34344ab23fe4fe20  |  v1.0.0   ||
|+---------------------------------------------------------------------------+-----------+|
