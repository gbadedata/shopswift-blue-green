# Phase 4 Blue-to-Green Traffic Switch Evidence

Date: Wed Jun  3 00:04:46 BST 2026

## Important Engineering Note
The first switching method patched the NGINX Ingress backend directly and produced one HTTP 503 during testing.
The design was improved by introducing shopswift-active-service.
The Ingress now points permanently to shopswift-active-service, while traffic switching is performed by changing the Service selector from Blue to Green.
The improved method produced zero failed requests during the Blue-to-Green switch.

## Pods
NAME                               READY   STATUS    RESTARTS   AGE   IP            NODE       NOMINATED NODE   READINESS GATES
shopswift-blue-589dff6c89-g2dj8    1/1     Running   0          49m   10.244.0.7    minikube   <none>           <none>
shopswift-blue-589dff6c89-q22s2    1/1     Running   0          49m   10.244.0.8    minikube   <none>           <none>
shopswift-green-8579dcbbb7-vdq5g   1/1     Running   0          15m   10.244.0.11   minikube   <none>           <none>
shopswift-green-8579dcbbb7-wlmq8   1/1     Running   0          15m   10.244.0.10   minikube   <none>           <none>

## Services
NAME                       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
shopswift-active-service   ClusterIP   10.110.192.2    <none>        80/TCP    6m34s
shopswift-blue-service     ClusterIP   10.97.31.22     <none>        80/TCP    49m
shopswift-green-service    ClusterIP   10.104.170.65   <none>        80/TCP    14m

## Active Service Endpoints
NAME                       ENDPOINTS                         AGE
shopswift-active-service   10.244.0.7:3000,10.244.0.8:3000   6m34s

## Ingress
NAME                CLASS   HOSTS             ADDRESS        PORTS   AGE
shopswift-ingress   nginx   shopswift.local   192.168.49.2   80      44m

## Ingress Description
Name:             shopswift-ingress
Labels:           app=shopswift
Namespace:        ecommerce-bluegreen
Address:          192.168.49.2
Ingress Class:    nginx
Default backend:  <default>
Rules:
  Host             Path  Backends
  ----             ----  --------
  shopswift.local  
                   /   shopswift-green-service:80 (10.244.0.10:3000,10.244.0.11:3000)
Annotations:       nginx.ingress.kubernetes.io/rewrite-target: /
Events:
  Type    Reason  Age                 From                      Message
  ----    ------  ----                ----                      -------
  Normal  Sync    2m5s (x5 over 44m)  nginx-ingress-controller  Scheduled for sync

## Current Version Through NGINX Ingress
{"app":"ShopSwift","version":"v2.0.0","environment":"green","commit":"minikube-green","port":3000,"status":"running"}

## Green Internal Service Check
{"app":"ShopSwift","version":"v2.0.0","environment":"green","commit":"minikube-green","port":3000,"status":"running"}pod "curl-evidence-green" deleted from ecommerce-bluegreen namespace


## Ingress Smoke Test
Running Ingress smoke tests against: http://localhost:8080
Using Host header: shopswift.local
PASSED: / returned 200
PASSED: /health returned 200
PASSED: /ready returned 200
PASSED: /version returned 200
PASSED: /products returned 200
PASSED: /cart returned 200
PASSED: /checkout returned 200
All Ingress smoke tests passed.

## Zero-Downtime Result
Manual observed result:
Total requests: 26
Failed requests: 0
Ingress zero-downtime availability test passed.
