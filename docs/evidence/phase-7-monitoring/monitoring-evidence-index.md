# Phase 10 Monitoring Screenshot and Evidence Index

Date: Wed Jun  3 12:28:36 BST 2026

## Evidence Files Captured

### Command Output Evidence
- monitoring-pods.txt
- monitoring-services.txt
- shopswift-pods.txt
- ingress-nginx-pods.txt

### Screenshot Evidence Required
- prometheus-targets-top.png
- prometheus-query-up.png
- prometheus-query-kube-pod-info-ecommerce-bluegreen.png
- grafana-home.png
- grafana-namespace-ecommerce-bluegreen.png
- grafana-shopswift-pods-visible.png
- grafana-ingress-nginx-namespace.png

## Monitoring Pods
NAME                                                     READY   STATUS    RESTARTS   AGE   IP               NODE                            NOMINATED NODE   READINESS GATES
alertmanager-monitoring-kube-prometheus-alertmanager-0   2/2     Running   0          87m   192.168.5.228    ip-192-168-7-185.ec2.internal   <none>           <none>
monitoring-grafana-7ff64d9bf9-srb5s                      3/3     Running   0          88m   192.168.45.114   ip-192-168-34-80.ec2.internal   <none>           <none>
monitoring-kube-prometheus-operator-5b6745fdf-bl8wr      1/1     Running   0          88m   192.168.44.49    ip-192-168-34-80.ec2.internal   <none>           <none>
monitoring-kube-state-metrics-99d68447-9glzk             1/1     Running   0          88m   192.168.18.44    ip-192-168-7-185.ec2.internal   <none>           <none>
monitoring-prometheus-node-exporter-5nqz5                1/1     Running   0          88m   192.168.7.185    ip-192-168-7-185.ec2.internal   <none>           <none>
monitoring-prometheus-node-exporter-99zbb                1/1     Running   0          88m   192.168.34.80    ip-192-168-34-80.ec2.internal   <none>           <none>
prometheus-monitoring-kube-prometheus-prometheus-0       2/2     Running   0          87m   192.168.33.201   ip-192-168-34-80.ec2.internal   <none>           <none>

## Monitoring Services
NAME                                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
alertmanager-operated                     ClusterIP   None             <none>        9093/TCP,9094/TCP,9094/UDP   88m
monitoring-grafana                        ClusterIP   10.100.243.27    <none>        80/TCP                       88m
monitoring-kube-prometheus-alertmanager   ClusterIP   10.100.154.150   <none>        9093/TCP,8080/TCP            88m
monitoring-kube-prometheus-operator       ClusterIP   10.100.247.245   <none>        443/TCP                      88m
monitoring-kube-prometheus-prometheus     ClusterIP   10.100.180.184   <none>        9090/TCP,8080/TCP            88m
monitoring-kube-state-metrics             ClusterIP   10.100.210.241   <none>        8080/TCP                     88m
monitoring-prometheus-node-exporter       ClusterIP   10.100.179.55    <none>        9100/TCP                     88m
prometheus-operated                       ClusterIP   None             <none>        9090/TCP                     88m

## ShopSwift Pods
NAME                               READY   STATUS    RESTARTS   AGE    IP               NODE                            NOMINATED NODE   READINESS GATES
shopswift-blue-564b747668-74b7k    1/1     Running   0          110m   192.168.28.211   ip-192-168-7-185.ec2.internal   <none>           <none>
shopswift-blue-564b747668-ktjjk    1/1     Running   0          110m   192.168.61.103   ip-192-168-34-80.ec2.internal   <none>           <none>
shopswift-green-7d7f9c6d46-7zq75   1/1     Running   0          110m   192.168.48.113   ip-192-168-34-80.ec2.internal   <none>           <none>
shopswift-green-7d7f9c6d46-9p625   1/1     Running   0          110m   192.168.5.9      ip-192-168-7-185.ec2.internal   <none>           <none>

## Ingress NGINX Pods
NAME                                        READY   STATUS    RESTARTS   AGE   IP               NODE                            NOMINATED NODE   READINESS GATES
ingress-nginx-controller-68886df798-qvq5n   1/1     Running   0          86m   192.168.36.141   ip-192-168-34-80.ec2.internal   <none>           <none>
ingress-nginx-controller-68886df798-wkzbx   1/1     Running   0          85m   192.168.52.127   ip-192-168-34-80.ec2.internal   <none>           <none>
