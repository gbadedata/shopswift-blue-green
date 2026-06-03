# Phase 10 AWS Prometheus and Grafana Monitoring Evidence

Date: Wed Jun  3 12:26:51 BST 2026

## Purpose
This phase adds observability to the AWS EKS Blue-Green deployment.
Prometheus collects Kubernetes and workload metrics.
Grafana visualizes cluster, namespace, pod, and ingress-related metrics.

## AWS EKS Cluster
--------------------------------------------------
|                 DescribeCluster                |
+--------------------------+---------+-----------+
|           name           | status  |  version  |
+--------------------------+---------+-----------+
|  shopswift-bluegreen-eks |  ACTIVE |  1.30     |
+--------------------------+---------+-----------+

## Kubernetes Context
arn:aws:eks:us-east-1:677276115158:cluster/shopswift-bluegreen-eks

## Nodes
NAME                            STATUS   ROLES    AGE     VERSION                INTERNAL-IP     EXTERNAL-IP      OS-IMAGE                        KERNEL-VERSION                    CONTAINER-RUNTIME
ip-192-168-34-80.ec2.internal   Ready    <none>   3h38m   v1.30.14-eks-3385e9b   192.168.34.80   100.55.100.187   Amazon Linux 2023.11.20260526   6.1.172-216.329.amzn2023.x86_64   containerd://2.2.3+unknown
ip-192-168-7-185.ec2.internal   Ready    <none>   3h38m   v1.30.14-eks-3385e9b   192.168.7.185   98.93.44.42      Amazon Linux 2023.11.20260526   6.1.172-216.329.amzn2023.x86_64   containerd://2.2.3+unknown

## Monitoring Namespace
NAME         STATUS   AGE
monitoring   Active   3h7m

## Monitoring Pods
NAME                                                     READY   STATUS    RESTARTS   AGE    IP               NODE                            NOMINATED NODE   READINESS GATES
alertmanager-monitoring-kube-prometheus-alertmanager-0   2/2     Running   0          3h5m   192.168.5.228    ip-192-168-7-185.ec2.internal   <none>           <none>
monitoring-grafana-7ff64d9bf9-srb5s                      3/3     Running   0          3h5m   192.168.45.114   ip-192-168-34-80.ec2.internal   <none>           <none>
monitoring-kube-prometheus-operator-5b6745fdf-bl8wr      1/1     Running   0          3h5m   192.168.44.49    ip-192-168-34-80.ec2.internal   <none>           <none>
monitoring-kube-state-metrics-99d68447-9glzk             1/1     Running   0          3h5m   192.168.18.44    ip-192-168-7-185.ec2.internal   <none>           <none>
monitoring-prometheus-node-exporter-5nqz5                1/1     Running   0          3h5m   192.168.7.185    ip-192-168-7-185.ec2.internal   <none>           <none>
monitoring-prometheus-node-exporter-99zbb                1/1     Running   0          3h5m   192.168.34.80    ip-192-168-34-80.ec2.internal   <none>           <none>
prometheus-monitoring-kube-prometheus-prometheus-0       2/2     Running   0          3h5m   192.168.33.201   ip-192-168-34-80.ec2.internal   <none>           <none>

## Monitoring Services
NAME                                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
alertmanager-operated                     ClusterIP   None             <none>        9093/TCP,9094/TCP,9094/UDP   3h5m
monitoring-grafana                        ClusterIP   10.100.243.27    <none>        80/TCP                       3h6m
monitoring-kube-prometheus-alertmanager   ClusterIP   10.100.154.150   <none>        9093/TCP,8080/TCP            3h6m
monitoring-kube-prometheus-operator       ClusterIP   10.100.247.245   <none>        443/TCP                      3h6m
monitoring-kube-prometheus-prometheus     ClusterIP   10.100.180.184   <none>        9090/TCP,8080/TCP            3h6m
monitoring-kube-state-metrics             ClusterIP   10.100.210.241   <none>        8080/TCP                     3h6m
monitoring-prometheus-node-exporter       ClusterIP   10.100.179.55    <none>        9100/TCP                     3h6m
prometheus-operated                       ClusterIP   None             <none>        9090/TCP                     3h5m

## Helm Releases
NAME         	NAMESPACE    	REVISION	UPDATED                                	STATUS  	CHART                       	APP VERSION
ingress-nginx	ingress-nginx	2       	2026-06-03 09:22:37.19334841 +0100 BST 	deployed	ingress-nginx-4.15.1        	1.15.1     
monitoring   	monitoring   	1       	2026-06-03 09:20:28.101561751 +0100 BST	deployed	kube-prometheus-stack-86.1.0	v0.91.0    

## NGINX Ingress Controller
NAME                                        READY   STATUS    RESTARTS   AGE    IP               NODE                            NOMINATED NODE   READINESS GATES
ingress-nginx-controller-68886df798-qvq5n   1/1     Running   0          3h4m   192.168.36.141   ip-192-168-34-80.ec2.internal   <none>           <none>
ingress-nginx-controller-68886df798-wkzbx   1/1     Running   0          3h3m   192.168.52.127   ip-192-168-34-80.ec2.internal   <none>           <none>
NAME                                 TYPE           CLUSTER-IP       EXTERNAL-IP                                                               PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   10.100.151.227   a0e06493a70e9402785bbae8ff74c035-1833017219.us-east-1.elb.amazonaws.com   80:31482/TCP,443:30140/TCP   3h32m
ingress-nginx-controller-admission   ClusterIP      10.100.239.254   <none>                                                                    443/TCP                      3h32m
ingress-nginx-controller-metrics     ClusterIP      10.100.179.3     <none>                                                                    10254/TCP                    3h4m

## ServiceMonitors
NAMESPACE       NAME                                                 AGE
ingress-nginx   ingress-nginx-controller                             3h4m
monitoring      monitoring-grafana                                   3h6m
monitoring      monitoring-kube-prometheus-alertmanager              3h6m
monitoring      monitoring-kube-prometheus-apiserver                 3h6m
monitoring      monitoring-kube-prometheus-coredns                   3h6m
monitoring      monitoring-kube-prometheus-kube-controller-manager   3h6m
monitoring      monitoring-kube-prometheus-kube-etcd                 3h6m
monitoring      monitoring-kube-prometheus-kube-proxy                3h6m
monitoring      monitoring-kube-prometheus-kube-scheduler            3h6m
monitoring      monitoring-kube-prometheus-kubelet                   3h6m
monitoring      monitoring-kube-prometheus-operator                  3h6m
monitoring      monitoring-kube-prometheus-prometheus                3h6m
monitoring      monitoring-kube-state-metrics                        3h6m
monitoring      monitoring-prometheus-node-exporter                  3h6m

## ShopSwift Pods
NAME                               READY   STATUS    RESTARTS   AGE     IP               NODE                            NOMINATED NODE   READINESS GATES
shopswift-blue-564b747668-74b7k    1/1     Running   0          3h28m   192.168.28.211   ip-192-168-7-185.ec2.internal   <none>           <none>
shopswift-blue-564b747668-ktjjk    1/1     Running   0          3h28m   192.168.61.103   ip-192-168-34-80.ec2.internal   <none>           <none>
shopswift-green-7d7f9c6d46-7zq75   1/1     Running   0          3h28m   192.168.48.113   ip-192-168-34-80.ec2.internal   <none>           <none>
shopswift-green-7d7f9c6d46-9p625   1/1     Running   0          3h28m   192.168.5.9      ip-192-168-7-185.ec2.internal   <none>           <none>

## ShopSwift Services
NAME                       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
shopswift-active-service   ClusterIP   10.100.38.206   <none>        80/TCP    3h28m
shopswift-blue-service     ClusterIP   10.100.86.193   <none>        80/TCP    3h28m
shopswift-green-service    ClusterIP   10.100.48.31    <none>        80/TCP    3h28m

## Current ShopSwift AWS Version
{"app":"ShopSwift","version":"v1.0.0","environment":"blue","commit":"aws-blue","port":3000,"status":"running"}

## Access Notes
Prometheus was accessed using:
kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9090:9090

Grafana was accessed using:
kubectl port-forward -n monitoring svc/monitoring-grafana 3001:80

Grafana login:
Username: admin
Password: stored in project notes for demo only; should be rotated for production.

## Result
Prometheus and Grafana were installed successfully on AWS EKS.
The monitoring stack observed the ShopSwift Blue-Green Kubernetes workloads before AWS teardown.
