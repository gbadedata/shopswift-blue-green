# ShopSwift: Blue-Green Deployment of a Containerized E-Commerce Application on Kubernetes

## Executive Summary

ShopSwift is a production-style Cloud and DevOps project that demonstrates how to implement Blue-Green deployment for zero-downtime releases using Docker, Kubernetes, GitHub Actions, NGINX Ingress Controller, AWS EKS, Amazon ECR, Prometheus, and Grafana.

The project started with local development, moved through Docker containerization, validated the deployment pattern on Minikube, then promoted the same architecture to AWS EKS. The final implementation proves application release, traffic switching, rollback, broken release protection, CI/CD validation, cloud deployment, and observability.

The core deployment model is:

```text
NGINX Ingress
    ↓
shopswift-active-service
    ↓ selector switch
Blue pods OR Green pods
```

This design keeps the Ingress stable and performs traffic switching by changing the selector of a Kubernetes Service. This avoids repeated Ingress backend patching and reduces the risk of traffic interruption during release changes.

---

## Project Requirement

The project requirement was to implement Blue-Green Deployment for zero-downtime releases using Docker, Kubernetes, GitHub Actions, AWS or Microsoft Azure, and NGINX Ingress Controller.

The requirement also stated that two production environments should be maintained to allow seamless traffic switching between the old and new versions, improving deployment reliability and rollback efficiency.

This project satisfies that requirement by implementing:

- A containerized e-commerce application.
- Separate Blue and Green Kubernetes deployments.
- Separate Blue and Green services.
- A stable active service used for traffic routing.
- NGINX Ingress Controller for external routing.
- Minikube local validation.
- AWS EKS cloud deployment.
- Amazon ECR image registry.
- GitHub Actions CI validation.
- Prometheus and Grafana monitoring.
- Broken release simulation.
- Rollback validation.
- Evidence files and screenshots.

---

## Technology Stack

| Area | Technology |
|---|---|
| Application | Node.js, Express |
| Testing | Jest, Supertest |
| Containerization | Docker |
| Local Kubernetes | Minikube |
| Cloud Kubernetes | AWS EKS |
| Container Registry | Amazon ECR |
| Ingress | NGINX Ingress Controller |
| CI/CD | GitHub Actions |
| Security Scanning | Trivy |
| Kubernetes Validation | kubeconform |
| Monitoring | Prometheus, Grafana |
| Package Management | Helm |
| Cloud CLI | AWS CLI, eksctl |

---

## Repository Structure

```text
.
├── .github
│   └── workflows
│       └── ci.yml
├── app
│   ├── Dockerfile
│   ├── package.json
│   ├── package-lock.json
│   ├── src
│   └── tests
├── cloud
│   └── aws
│       └── eksctl-cluster.yaml
├── docs
│   └── evidence
│       ├── phase-1-local-app
│       ├── phase-2-docker
│       ├── phase-3-minikube
│       ├── phase-4-blue-green
│       ├── phase-5-github-actions
│       ├── phase-09-aws-eks
│       └── phase-10-monitoring
├── k8s
│   ├── namespace.yaml
│   ├── blue-deployment.yaml
│   ├── green-deployment.yaml
│   ├── broken-green-deployment.yaml
│   ├── blue-service.yaml
│   ├── green-service.yaml
│   ├── active-service.yaml
│   ├── ingress.yaml
│   └── aws
│       ├── namespace.yaml
│       ├── blue-deployment.yaml
│       ├── green-deployment.yaml
│       ├── services.yaml
│       └── ingress.yaml
├── scripts
│   ├── smoke-test.sh
│   ├── ingress-smoke-test.sh
│   ├── ingress-zero-downtime-test.sh
│   ├── switch-to-blue.sh
│   ├── switch-to-green.sh
│   ├── aws-switch-to-blue.sh
│   ├── aws-switch-to-green.sh
│   ├── aws-ingress-smoke-test.sh
│   └── aws-ingress-zero-downtime-test.sh
└── README.md
```

---

## Application Overview

ShopSwift is a simple e-commerce API used to demonstrate deployment behaviour.

### Main Endpoints

| Endpoint | Purpose |
|---|---|
| `/` | Application landing endpoint |
| `/health` | Liveness probe endpoint |
| `/ready` | Readiness probe endpoint |
| `/version` | Shows current version and environment |
| `/products` | Simulated product catalogue |
| `/products/:id` | Simulated product detail |
| `/cart` | Simulated cart endpoint |
| `/checkout` | Simulated checkout endpoint |
| `/metrics` | Metrics endpoint for observability |

The `/version` endpoint is critical because it proves which environment is currently serving traffic.

Example Blue response:

```json
{
  "app": "ShopSwift",
  "version": "v1.0.0",
  "environment": "blue",
  "commit": "aws-blue",
  "port": 3000,
  "status": "running"
}
```

Example Green response:

```json
{
  "app": "ShopSwift",
  "version": "v2.0.0",
  "environment": "green",
  "commit": "aws-green",
  "port": 3000,
  "status": "running"
}
```

---

## Deployment Architecture

### Final Traffic Routing Model

```text
User / curl / browser
        ↓
AWS Load Balancer or local port-forward
        ↓
NGINX Ingress Controller
        ↓
shopswift-ingress
        ↓
shopswift-active-service
        ↓
selector: environment=blue OR environment=green
        ↓
Blue pods OR Green pods
```

### Why the Active Service Design Was Used

The first implementation switched traffic by patching the NGINX Ingress backend directly:

```text
Ingress backend: shopswift-blue-service → shopswift-green-service
```

During testing, this caused one HTTP 503 response. That was not acceptable for a zero-downtime claim.

The design was improved by introducing:

```text
shopswift-active-service
```

The Ingress now points permanently to this active service. Traffic switching happens by changing the service selector:

```json
{"app":"shopswift","environment":"blue"}
```

or:

```json
{"app":"shopswift","environment":"green"}
```

This improved design produced zero failed requests during traffic switching and rollback.

---

## Project Phases

### Phase 1 — Local Application Build

Completed work:

- Created ShopSwift API.
- Added e-commerce simulation endpoints.
- Added `/health`, `/ready`, and `/version`.
- Added tests with Jest and Supertest.
- Confirmed all tests passed.

Test result:

```text
Test Suites: 1 passed
Tests: 7 passed, 7 total
```

Purpose: validate the application before containerization.

---

### Phase 2 — Dockerization

Completed work:

- Created production Dockerfile.
- Built Docker image.
- Ran application inside Docker.
- Verified `/health`, `/ready`, `/version`, `/products`, `/cart`, and `/checkout`.
- Created smoke test scripts.

Docker images:

```text
shopswift:v1.0.0
shopswift:v2.0.0
```

Important fix:

Docker build initially failed because `package-lock.json` was out of sync with `package.json`. The lock file was regenerated and the Docker build succeeded.

---

### Phase 3 — Git and GitHub Baseline

Completed work:

- Initialized local Git repository.
- Created GitHub repository.
- Added `.gitignore`.
- Added folder placeholders.
- Pushed project to GitHub.

Repository:

```text
https://github.com/gbadedata/shopswift-blue-green
```

---

### Phase 4 — Minikube Blue Baseline with NGINX Ingress

Completed work:

- Started Minikube.
- Enabled NGINX Ingress Controller.
- Created Kubernetes namespace.
- Deployed Blue environment.
- Created Blue service.
- Created Ingress.
- Tested Blue internally.
- Tested Blue through NGINX Ingress.

Because Minikube was running inside WSL using the Docker driver, direct `shopswift.local` access was unreliable. The reliable test path used port-forwarding:

```bash
kubectl port-forward -n ingress-nginx service/ingress-nginx-controller 8080:80
```

Then requests were sent with the correct Host header:

```bash
curl -H "Host: shopswift.local" http://localhost:8080/version
```

---

### Phase 5 — Minikube Blue-to-Green Traffic Switch

Completed work:

- Deployed Green environment.
- Created Green service.
- Tested Green internally before routing traffic.
- Created active service.
- Switched traffic from Blue to Green using service selector patching.
- Ran continuous zero-downtime test.

Final result:

```text
Blue to Green:
Total requests: 26
Failed requests: 0
Ingress zero-downtime availability test passed.
```

---

### Phase 6 — Minikube Green-to-Blue Rollback

Completed work:

- Kept Blue running as a warm standby.
- Switched traffic from Green back to Blue.
- Ran continuous zero-downtime rollback test.

Final result:

```text
Green to Blue:
Total requests: 25
Failed requests: 0
Ingress zero-downtime availability test passed.
```

---

### Phase 7 — Broken Green Release Simulation

Completed work:

- Created a broken Green deployment.
- Set `FORCE_NOT_READY=true`.
- Forced `/ready` to return HTTP 503.
- Confirmed Green rollout timed out.
- Confirmed live traffic remained on Blue.
- Restored healthy Green after capturing evidence.

Key outcome:

```text
Broken Green failed readiness.
Live Blue traffic remained healthy.
Smoke test still passed.
```

This phase proves that unsafe releases are blocked before traffic is switched.

---

### Phase 8 — GitHub Actions CI/CD Validation

Completed work:

- Created GitHub Actions workflow.
- Installed Node.js dependencies.
- Ran unit tests.
- Built Docker image.
- Ran Trivy scan.
- Validated Kubernetes manifests using kubeconform.

Workflow:

```text
.github/workflows/ci.yml
```

CI result:

```text
ShopSwift CI passed
```

Important fix:

The initial Trivy action version failed because the workflow referenced an unresolved version. It was corrected by pinning a valid Trivy Action version and Trivy binary version.

---

### Phase 9 — AWS EKS Cloud Deployment and Blue-Green Validation

Completed work:

- Created Amazon ECR repository.
- Built and pushed Docker images to ECR.
- Created AWS EKS cluster using eksctl.
- Installed NGINX Ingress Controller using Helm.
- Deployed Blue and Green environments to AWS EKS.
- Created active service.
- Created AWS Ingress.
- Validated Blue baseline through AWS Load Balancer.
- Switched Blue to Green.
- Rolled Green back to Blue.
- Captured AWS evidence.

AWS account used:

```text
677276115158
```

ECR repository:

```text
677276115158.dkr.ecr.us-east-1.amazonaws.com/shopswift
```

AWS EKS cluster:

```text
shopswift-bluegreen-eks
```

AWS Blue-to-Green result:

```text
Total requests: 21
Failed requests: 0
AWS Ingress zero-downtime availability test passed.
```

AWS Green-to-Blue rollback result:

```text
Total requests: 23
Failed requests: 0
AWS Ingress zero-downtime availability test passed.
```

---

### Phase 10 — AWS Prometheus and Grafana Monitoring

Completed work:

- Installed kube-prometheus-stack on AWS EKS.
- Installed Prometheus.
- Installed Grafana.
- Verified monitoring pods.
- Verified Prometheus targets.
- Verified Grafana dashboards.
- Generated traffic for metrics.
- Captured screenshots and command output evidence.

Monitoring stack:

```text
Prometheus
Grafana
Alertmanager
kube-state-metrics
node-exporter
Prometheus Operator
```

Evidence captured:

- Prometheus target health.
- Prometheus `up` query.
- `kube_pod_info{namespace="ecommerce-bluegreen"}`.
- `kube_deployment_status_replicas_available{namespace="ecommerce-bluegreen"}`.
- `container_cpu_usage_seconds_total{namespace="ecommerce-bluegreen"}`.
- Grafana namespace dashboard for `ecommerce-bluegreen`.
- Grafana namespace dashboard for `ingress-nginx`.
- Grafana namespace dashboard for `monitoring`.
- ShopSwift Blue and Green pod visibility.
- Kubernetes command output evidence.

Important limitation:

```text
The monitoring evidence proves infrastructure and Kubernetes observability.
It does not claim business-level observability such as order revenue, user conversion, or checkout value.
```

---

## Key Scripts

### Local smoke test

```bash
./scripts/smoke-test.sh http://localhost:3000
```

### Local Ingress smoke test

```bash
./scripts/ingress-smoke-test.sh http://localhost:8080 shopswift.local
```

### Local zero-downtime test

```bash
./scripts/ingress-zero-downtime-test.sh http://localhost:8080 shopswift.local 30
```

### Switch local active service to Green

```bash
./scripts/switch-to-green.sh
```

### Switch local active service to Blue

```bash
./scripts/switch-to-blue.sh
```

### AWS smoke test

```bash
./scripts/aws-ingress-smoke-test.sh "$AWS_INGRESS_HOST" shopswift.aws.local
```

### AWS zero-downtime test

```bash
./scripts/aws-ingress-zero-downtime-test.sh "$AWS_INGRESS_HOST" shopswift.aws.local 30
```

### AWS switch to Green

```bash
./scripts/aws-switch-to-green.sh
```

### AWS switch to Blue

```bash
./scripts/aws-switch-to-blue.sh
```

---

## How to Run Locally with Docker

From the app directory:

```bash
cd app
npm ci
npm test
docker build -t shopswift:v1.0.0 .
docker run --rm -p 3000:3000 \
  -e APP_VERSION=v1.0.0 \
  -e APP_ENV=blue \
  -e GIT_COMMIT=local-docker \
  shopswift:v1.0.0
```

Test:

```bash
curl http://localhost:3000/health
curl http://localhost:3000/ready
curl http://localhost:3000/version
curl http://localhost:3000/products
```

---

## How to Run on Minikube

Start Minikube:

```bash
minikube start --driver=docker
minikube addons enable ingress
```

Load Docker images:

```bash
minikube image load shopswift:v1.0.0
minikube image load shopswift:v2.0.0
```

Apply manifests:

```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/blue-deployment.yaml
kubectl apply -f k8s/green-deployment.yaml
kubectl apply -f k8s/blue-service.yaml
kubectl apply -f k8s/green-service.yaml
kubectl apply -f k8s/active-service.yaml
kubectl apply -f k8s/ingress.yaml
```

Port-forward NGINX Ingress:

```bash
kubectl port-forward -n ingress-nginx service/ingress-nginx-controller 8080:80
```

Test:

```bash
curl -H "Host: shopswift.local" http://localhost:8080/version
```

---

## How to Run on AWS EKS

Set variables:

```bash
export AWS_REGION=us-east-1
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
export ECR_REPO_NAME=shopswift
export EKS_CLUSTER_NAME=shopswift-bluegreen-eks
```

Authenticate Docker to ECR:

```bash
aws ecr get-login-password --region "$AWS_REGION" | \
docker login \
  --username AWS \
  --password-stdin "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
```

Push images:

```bash
docker tag shopswift:v1.0.0 "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:v1.0.0"
docker tag shopswift:v2.0.0 "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:v2.0.0"

docker push "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:v1.0.0"
docker push "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:v2.0.0"
```

Create EKS cluster:

```bash
eksctl create cluster -f cloud/aws/eksctl-cluster.yaml
```

Install NGINX Ingress Controller:

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.replicaCount=2 \
  --set controller.service.type=LoadBalancer
```

Deploy ShopSwift:

```bash
kubectl apply -f k8s/aws/namespace.yaml
kubectl apply -f k8s/aws/blue-deployment.yaml
kubectl apply -f k8s/aws/green-deployment.yaml
kubectl apply -f k8s/aws/services.yaml
kubectl apply -f k8s/aws/ingress.yaml
```

Get AWS Load Balancer hostname:

```bash
export AWS_INGRESS_HOST=$(kubectl get svc ingress-nginx-controller \
  -n ingress-nginx \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
```

Test:

```bash
curl -H "Host: shopswift.aws.local" http://$AWS_INGRESS_HOST/version
```

---

## Monitoring Setup on AWS EKS

Install kube-prometheus-stack:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set grafana.adminPassword='ShopSwiftAdmin123!' \
  --set grafana.service.type=ClusterIP \
  --set prometheus.service.type=ClusterIP \
  --set alertmanager.enabled=true
```

Enable NGINX metrics:

```bash
helm upgrade ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --reuse-values \
  --set controller.metrics.enabled=true \
  --set controller.metrics.serviceMonitor.enabled=true \
  --set controller.metrics.serviceMonitor.additionalLabels.release=monitoring
```

Access Prometheus:

```bash
kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9090:9090
```

Open:

```text
http://localhost:9090
```

Access Grafana:

```bash
kubectl port-forward -n monitoring svc/monitoring-grafana 3001:80
```

Open:

```text
http://localhost:3001
```

Login:

```text
Username: admin
Password: ShopSwiftAdmin123!
```

For production, the Grafana password should be stored in a secure secret manager and rotated.

---

## Evidence Summary

Evidence is stored under:

```text
docs/evidence/
```

Important evidence includes:

| Evidence | Location |
|---|---|
| Local app evidence | `docs/evidence/phase-1-local-app/` |
| Docker evidence | `docs/evidence/phase-2-docker/` |
| Minikube Blue baseline | `docs/evidence/phase-3-minikube/` |
| Blue-Green switching and rollback | `docs/evidence/phase-4-blue-green/` |
| GitHub Actions CI | `docs/evidence/phase-5-github-actions/` |
| AWS EKS cloud deployment | `docs/evidence/phase-09-aws-eks/` |
| Prometheus/Grafana monitoring | `docs/evidence/phase-10-monitoring/` |

Key proven results:

```text
Minikube Blue → Green failed requests: 0
Minikube Green → Blue failed requests: 0
AWS EKS Blue → Green failed requests: 0
AWS EKS Green → Blue failed requests: 0
Broken Green release blocked by readiness failure
GitHub Actions CI passed
Prometheus and Grafana monitoring installed and verified
```

---

## Key Engineering Challenges and Fixes

### 1. Docker Build Failure

Problem:

```text
npm ci --omit=dev failed
```

Cause:

```text
package-lock.json was not aligned with package.json.
```

Fix:

```text
Regenerated package-lock.json and rebuilt the image.
```

---

### 2. Local App vs Docker App Confusion

Problem:

```text
The local Node.js app and Docker container both used port 3000 at different times.
```

Fix:

```text
Used /version metadata to verify exactly which runtime was serving traffic.
```

---

### 3. Minikube Ingress Access Issue

Problem:

```text
shopswift.local did not connect directly through Minikube IP.
```

Cause:

```text
WSL + Minikube Docker driver networking limitation.
```

Fix:

```text
Used port-forward to the NGINX Ingress Controller and passed the Host header manually.
```

---

### 4. Ingress Patching Caused 503

Problem:

```text
Directly patching the Ingress backend caused one HTTP 503 during traffic switch.
```

Fix:

```text
Introduced shopswift-active-service and switched traffic using service selector patching.
```

---

### 5. Old Scripts Still Patched Ingress

Problem:

```text
The architecture had changed but the scripts still patched the Ingress.
```

Fix:

```text
Rewrote scripts to patch the active service selector only.
```

Validation:

```bash
grep -n "patch service" scripts/switch-to-green.sh scripts/switch-to-blue.sh
grep -n "patch ingress" scripts/switch-to-green.sh scripts/switch-to-blue.sh || echo "No ingress patching in switch scripts"
```

---

### 6. GitHub Actions Trivy Version Failure

Problem:

```text
GitHub Actions could not resolve the original Trivy action version.
```

Fix:

```text
Pinned a valid Trivy action version and Trivy binary version.
```

---

### 7. Screenshot Evidence Pollution

Problem:

```text
A broad copy command copied unrelated screenshots from Downloads into the evidence folder.
```

Fix:

```text
Deleted the polluted screenshots folder, recreated it, and copied only files from Downloads/screen.
```

Lesson:

```text
Never copy all files from Downloads into project evidence. Use a dedicated source folder.
```

---

## Defence Talking Points

### Why Blue-Green Deployment?

Blue-Green deployment reduces release risk by keeping two environments:

```text
Blue = current stable version
Green = new candidate version
```

The new version is deployed and tested before receiving traffic. If it fails, traffic remains on Blue. If it succeeds, traffic moves to Green. If Green later fails, traffic can be quickly switched back to Blue.

### Why Kubernetes?

Kubernetes provides declarative deployment, replication, service discovery, readiness probes, liveness probes, Ingress routing, namespace isolation, and cloud portability.

### Why NGINX Ingress?

NGINX Ingress provides external HTTP routing into the cluster. In this project, it routes traffic based on host rules to the stable active service.

### Why Active Service Instead of Patching Ingress?

Patching Ingress directly caused a 503 during testing. The active service model keeps the Ingress stable and changes only the backend pod selector. This produced zero failed requests.

### Why Readiness Probes?

Readiness probes prevent unsafe pods from receiving traffic. The broken Green simulation proved this. Green failed readiness, the rollout did not complete, and live Blue traffic remained healthy.

### Why Prometheus and Grafana?

Prometheus and Grafana add observability. They allow the team to see Kubernetes workloads, pods, namespaces, ingress metrics, CPU usage, network traffic, and deployment health.

---

## Current Project Status

Completed:

```text
Phase 1 — Local application
Phase 2 — Dockerization
Phase 3 — Git/GitHub baseline
Phase 4 — Minikube Blue baseline
Phase 5 — Minikube Blue-to-Green switch
Phase 6 — Minikube rollback
Phase 7 — Broken Green release simulation
Phase 8 — GitHub Actions CI/CD validation
Phase 9 — AWS EKS deployment and Blue-Green validation
Phase 10 — AWS Prometheus and Grafana monitoring
```

The project is now at a strong defence-ready stage.

---

## Cost Warning and Cleanup

AWS EKS, EC2 worker nodes, Load Balancers, and ECR storage can generate charges.

After capturing final evidence, delete AWS resources.

Recommended cleanup:

```bash
eksctl delete cluster --name shopswift-bluegreen-eks --region us-east-1
```

Then confirm:

```bash
aws eks list-clusters --region us-east-1
aws elbv2 describe-load-balancers --region us-east-1
aws ec2 describe-instances --region us-east-1
aws ec2 describe-nat-gateways --region us-east-1
aws ec2 describe-volumes --region us-east-1
```

Do not leave the EKS cluster running unnecessarily.

---

## Final Outcome

This project demonstrates a complete local-to-cloud DevOps release workflow:

```text
Code
  ↓
Tests
  ↓
Docker image
  ↓
Local Kubernetes validation
  ↓
Blue-Green release
  ↓
Rollback
  ↓
Broken release protection
  ↓
CI validation
  ↓
AWS EKS cloud deployment
  ↓
Prometheus/Grafana observability
```

The implementation proves not just that an application can be deployed, but that it can be released, validated, observed, and rolled back using industry-standard Cloud and DevOps practices.
