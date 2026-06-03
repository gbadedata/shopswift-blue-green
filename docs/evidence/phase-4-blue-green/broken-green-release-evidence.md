# Phase 7 Broken Green Release Simulation Evidence

Date: Wed Jun  3 01:37:12 BST 2026

## Purpose
This phase proves that an unsafe Green release can be detected before production traffic is switched.

## Failure Mechanism
The broken Green release sets FORCE_NOT_READY=true.
This causes the /ready endpoint to return HTTP 503.
Kubernetes readiness probes therefore prevent the broken release from becoming safe for production traffic.

## Rollout Result
The rollout of the broken Green deployment timed out, which is expected because the readiness probe fails.

## Ingress Backend
Rules:
  Host             Path  Backends
  ----             ----  --------
  shopswift.local  
                   /   shopswift-active-service:80 (10.244.0.7:3000,10.244.0.8:3000)
Annotations:       nginx.ingress.kubernetes.io/rewrite-target: /
Events:
  Type    Reason  Age                From                      Message
  ----    ------  ----               ----                      -------

## Active Service Selector
{"app":"shopswift","environment":"blue"}

## Current Live Version
{"app":"ShopSwift","version":"v1.0.0","environment":"blue","commit":"minikube-blue","port":3000,"status":"running"}

## All Pods
NAME                               READY   STATUS    RESTARTS   AGE     IP            NODE       NOMINATED NODE   READINESS GATES
shopswift-blue-589dff6c89-g2dj8    1/1     Running   0          142m    10.244.0.7    minikube   <none>           <none>
shopswift-blue-589dff6c89-q22s2    1/1     Running   0          142m    10.244.0.8    minikube   <none>           <none>
shopswift-green-598d4f594b-xbqr2   0/1     Running   0          6m50s   10.244.0.17   minikube   <none>           <none>
shopswift-green-8579dcbbb7-vdq5g   1/1     Running   0          107m    10.244.0.11   minikube   <none>           <none>
shopswift-green-8579dcbbb7-wlmq8   1/1     Running   0          107m    10.244.0.10   minikube   <none>           <none>

## Green Pods
NAME                               READY   STATUS    RESTARTS   AGE     IP            NODE       NOMINATED NODE   READINESS GATES
shopswift-green-598d4f594b-xbqr2   0/1     Running   0          6m50s   10.244.0.17   minikube   <none>           <none>
shopswift-green-8579dcbbb7-vdq5g   1/1     Running   0          107m    10.244.0.11   minikube   <none>           <none>
shopswift-green-8579dcbbb7-wlmq8   1/1     Running   0          107m    10.244.0.10   minikube   <none>           <none>

## Green Deployment Conditions
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    ReplicaSetUpdated
OldReplicaSets:  shopswift-green-8579dcbbb7 (2/2 replicas created)
NewReplicaSet:   shopswift-green-598d4f594b (1/1 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  6m51s  deployment-controller  Scaled up replica set shopswift-green-598d4f594b from 0 to 1

## Green Pod Readiness Events
Events:
  Type     Reason     Age                   From               Message
  ----     ------     ----                  ----               -------
  Normal   Scheduled  6m50s                 default-scheduler  Successfully assigned ecommerce-bluegreen/shopswift-green-598d4f594b-xbqr2 to minikube
  Normal   Pulled     6m49s                 kubelet            Container image "shopswift:v2.0.0" already present on machine and can be accessed by the pod
  Normal   Created    6m48s                 kubelet            Container created
  Normal   Started    6m48s                 kubelet            Container started
  Warning  Unhealthy  6m42s                 kubelet            Readiness probe failed: Get "http://10.244.0.17:3000/ready": dial tcp 10.244.0.17:3000: connect: connection refused
  Warning  Unhealthy  71s (x62 over 6m37s)  kubelet            Readiness probe failed: HTTP probe failed with statuscode: 503


Name:             shopswift-green-8579dcbbb7-vdq5g
Namespace:        ecommerce-bluegreen
Priority:         0
Service Account:  default
Node:             minikube/192.168.49.2
Start Time:       Tue, 02 Jun 2026 23:49:35 +0100
--
Events:                      <none>


Name:             shopswift-green-8579dcbbb7-wlmq8
Namespace:        ecommerce-bluegreen
Priority:         0
Service Account:  default
Node:             minikube/192.168.49.2
Start Time:       Tue, 02 Jun 2026 23:49:35 +0100
--
Events:                      <none>

## Live Traffic Smoke Test
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

## Result
Broken Green was detected through readiness failure.
Live traffic remained on stable Blue.
The live smoke test still passed.
This proves that unsafe releases must be blocked before traffic switching.
