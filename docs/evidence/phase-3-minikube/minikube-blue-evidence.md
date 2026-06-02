# Phase 3 Minikube Blue Deployment Evidence

Date: Tue Jun  2 23:43:35 BST 2026

## Minikube Status
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured


## Kubernetes Nodes
NAME       STATUS   ROLES           AGE   VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION                      CONTAINER-RUNTIME
minikube   Ready    control-plane   86m   v1.35.1   192.168.49.2   <none>        Debian GNU/Linux 12 (bookworm)   6.6.114.1-microsoft-standard-WSL2   docker://29.2.1

## Ingress Controller Pods
NAME                                        READY   STATUS      RESTARTS   AGE
ingress-nginx-admission-create-2kzw8        0/1     Completed   0          32m
ingress-nginx-admission-patch-p8df9         0/1     Completed   1          32m
ingress-nginx-controller-596f8778bc-bkts9   1/1     Running     0          32m

## Ingress Controller Service
NAME                                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
ingress-nginx-controller             NodePort    10.107.15.230   <none>        80:30640/TCP,443:31777/TCP   32m
ingress-nginx-controller-admission   ClusterIP   10.103.158.96   <none>        443/TCP                      32m

## Namespace
NAME                  STATUS   AGE
ecommerce-bluegreen   Active   29m

## Blue Deployment
NAME             READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES             SELECTOR
shopswift-blue   2/2     2            2           28m   shopswift    shopswift:v1.0.0   app=shopswift,environment=blue

## Blue Pods
NAME                              READY   STATUS    RESTARTS   AGE   IP           NODE       NOMINATED NODE   READINESS GATES
shopswift-blue-589dff6c89-g2dj8   1/1     Running   0          28m   10.244.0.7   minikube   <none>           <none>
shopswift-blue-589dff6c89-q22s2   1/1     Running   0          28m   10.244.0.8   minikube   <none>           <none>

## Services
NAME                     TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
shopswift-blue-service   ClusterIP   10.97.31.22   <none>        80/TCP    28m

## Ingress
NAME                CLASS   HOSTS             ADDRESS        PORTS   AGE
shopswift-ingress   nginx   shopswift.local   192.168.49.2   80      23m

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
                   /   shopswift-blue-service:80 (10.244.0.7:3000,10.244.0.8:3000)
Annotations:       nginx.ingress.kubernetes.io/rewrite-target: /
Events:
  Type    Reason  Age                From                      Message
  ----    ------  ----               ----                      -------
  Normal  Sync    22m (x2 over 23m)  nginx-ingress-controller  Scheduled for sync

## Version Endpoint Through NGINX Ingress Port Forward
{"app":"ShopSwift","version":"v1.0.0","environment":"blue","commit":"minikube-blue","port":3000,"status":"running"}

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
