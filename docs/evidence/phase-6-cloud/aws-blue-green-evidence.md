# Phase 9 AWS EKS Blue-Green Deployment Evidence

Date: Wed Jun  3 09:12:12 BST 2026

## AWS Ingress Host
a0e06493a70e9402785bbae8ff74c035-1833017219.us-east-1.elb.amazonaws.com

## Architecture
AWS Load Balancer routes traffic to the NGINX Ingress Controller.
NGINX Ingress routes to shopswift-active-service.
shopswift-active-service switches between Blue and Green using selector changes.
The Ingress backend remains stable while the active Service selector changes.

## EKS Cluster
--------------------------------------------------
|                 DescribeCluster                |
+--------------------------+---------+-----------+
|           name           | status  |  version  |
+--------------------------+---------+-----------+
|  shopswift-bluegreen-eks |  ACTIVE |  1.30     |
+--------------------------+---------+-----------+

## Nodes
NAME                            STATUS   ROLES    AGE   VERSION                INTERNAL-IP     EXTERNAL-IP      OS-IMAGE                        KERNEL-VERSION                    CONTAINER-RUNTIME
ip-192-168-34-80.ec2.internal   Ready    <none>   23m   v1.30.14-eks-3385e9b   192.168.34.80   100.55.100.187   Amazon Linux 2023.11.20260526   6.1.172-216.329.amzn2023.x86_64   containerd://2.2.3+unknown
ip-192-168-7-185.ec2.internal   Ready    <none>   23m   v1.30.14-eks-3385e9b   192.168.7.185   98.93.44.42      Amazon Linux 2023.11.20260526   6.1.172-216.329.amzn2023.x86_64   containerd://2.2.3+unknown

## Ingress Controller
NAME                                       READY   STATUS    RESTARTS   AGE
ingress-nginx-controller-d6f5f6d89-fq69t   1/1     Running   0          18m
ingress-nginx-controller-d6f5f6d89-pcdll   1/1     Running   0          18m
NAME                                 TYPE           CLUSTER-IP       EXTERNAL-IP                                                               PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   10.100.151.227   a0e06493a70e9402785bbae8ff74c035-1833017219.us-east-1.elb.amazonaws.com   80:31482/TCP,443:30140/TCP   18m
ingress-nginx-controller-admission   ClusterIP      10.100.239.254   <none>                                                                    443/TCP                      18m

## ShopSwift Pods
NAME                               READY   STATUS    RESTARTS   AGE   IP               NODE                            NOMINATED NODE   READINESS GATES
shopswift-blue-564b747668-74b7k    1/1     Running   0          13m   192.168.28.211   ip-192-168-7-185.ec2.internal   <none>           <none>
shopswift-blue-564b747668-ktjjk    1/1     Running   0          13m   192.168.61.103   ip-192-168-34-80.ec2.internal   <none>           <none>
shopswift-green-7d7f9c6d46-7zq75   1/1     Running   0          13m   192.168.48.113   ip-192-168-34-80.ec2.internal   <none>           <none>
shopswift-green-7d7f9c6d46-9p625   1/1     Running   0          13m   192.168.5.9      ip-192-168-7-185.ec2.internal   <none>           <none>

## ShopSwift Services
NAME                       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
shopswift-active-service   ClusterIP   10.100.38.206   <none>        80/TCP    13m
shopswift-blue-service     ClusterIP   10.100.86.193   <none>        80/TCP    13m
shopswift-green-service    ClusterIP   10.100.48.31    <none>        80/TCP    13m

## Ingress
NAME                CLASS   HOSTS                 ADDRESS                                                                   PORTS   AGE
shopswift-ingress   nginx   shopswift.aws.local   a0e06493a70e9402785bbae8ff74c035-1833017219.us-east-1.elb.amazonaws.com   80      13m
Rules:
  Host                 Path  Backends
  ----                 ----  --------
  shopswift.aws.local  
                       /   shopswift-active-service:80 (192.168.61.103:3000,192.168.28.211:3000)
Annotations:           nginx.ingress.kubernetes.io/rewrite-target: /
Events:
  Type    Reason  Age                From                      Message
  ----    ------  ----               ----                      -------

## Active Service Selector
{"app":"shopswift","environment":"blue"}

## Current AWS Version
{"app":"ShopSwift","version":"v1.0.0","environment":"blue","commit":"aws-blue","port":3000,"status":"running"}

## AWS Smoke Test
Running AWS Ingress smoke tests against: http://a0e06493a70e9402785bbae8ff74c035-1833017219.us-east-1.elb.amazonaws.com
Using Host header: shopswift.aws.local
PASSED: / returned 200
PASSED: /health returned 200
PASSED: /ready returned 200
PASSED: /version returned 200
PASSED: /products returned 200
PASSED: /cart returned 200
PASSED: /checkout returned 200
All AWS Ingress smoke tests passed.

## AWS Blue to Green Zero-Downtime Result
Total requests: 21
Failed requests: 0
AWS Ingress zero-downtime availability test passed.

## AWS Green to Blue Rollback Result
Total requests: 23
Failed requests: 0
AWS Ingress zero-downtime availability test passed.

## Result
The same Blue-Green deployment strategy validated locally with Minikube was successfully promoted to AWS EKS.
Both cloud traffic switch and cloud rollback completed with zero failed requests.
