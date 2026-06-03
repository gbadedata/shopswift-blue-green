# Phase 4 Blue-Green Traffic Switching and Rollback Evidence

Date: Wed Jun  3 01:06:31 BST 2026

## Final Architecture Decision
The Ingress points permanently to shopswift-active-service.
Traffic switching is performed by changing the selector of shopswift-active-service.
This avoids patching the Ingress backend during release switching.

## Ingress Backend
Rules:
  Host             Path  Backends
  ----             ----  --------
  shopswift.local  
                   /   shopswift-active-service:80 (10.244.0.7:3000,10.244.0.8:3000)
Annotations:       nginx.ingress.kubernetes.io/rewrite-target: /
Events:
  Type    Reason  Age                  From                      Message
  ----    ------  ----                 ----                      -------

## Active Service Selector
{"app":"shopswift","environment":"blue"}

## Pods
NAME                               READY   STATUS    RESTARTS   AGE    IP            NODE       NOMINATED NODE   READINESS GATES
shopswift-blue-589dff6c89-g2dj8    1/1     Running   0          111m   10.244.0.7    minikube   <none>           <none>
shopswift-blue-589dff6c89-q22s2    1/1     Running   0          111m   10.244.0.8    minikube   <none>           <none>
shopswift-green-8579dcbbb7-vdq5g   1/1     Running   0          76m    10.244.0.11   minikube   <none>           <none>
shopswift-green-8579dcbbb7-wlmq8   1/1     Running   0          76m    10.244.0.10   minikube   <none>           <none>

## Services
NAME                       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
shopswift-active-service   ClusterIP   10.110.192.2    <none>        80/TCP    68m
shopswift-blue-service     ClusterIP   10.97.31.22     <none>        80/TCP    110m
shopswift-green-service    ClusterIP   10.104.170.65   <none>        80/TCP    75m

## Active Service Endpoints
NAME                       ENDPOINTS                         AGE
shopswift-active-service   10.244.0.7:3000,10.244.0.8:3000   68m

## Current Version
{"app":"ShopSwift","version":"v1.0.0","environment":"blue","commit":"minikube-blue","port":3000,"status":"running"}

## Script Check
scripts/switch-to-green.sh:9:kubectl patch service "$SERVICE_NAME" \
scripts/switch-to-blue.sh:9:kubectl patch service "$SERVICE_NAME" \
No ingress patching in switch scripts

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

## Blue to Green Zero-Downtime Result

Total requests: 26
Failed requests: 0
Ingress zero-downtime availability test passed.

## Green to Blue Rollback Result

Total requests: 25
Failed requests: 0
Ingress zero-downtime availability test passed.
