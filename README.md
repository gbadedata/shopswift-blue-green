# ShopSwift: Local-to-Cloud Blue-Green Deployment

ShopSwift is a simple e-commerce web application used to demonstrate Blue-Green deployment for zero-downtime releases.

The project follows a local-to-cloud delivery model:

1. Build and test the application locally.
2. Containerize the application with Docker.
3. Validate Kubernetes deployment locally using Minikube.
4. Use NGINX Ingress Controller to switch traffic between Blue and Green environments.
5. Test rollback and failed release behaviour.
6. Promote the same deployment model to a cloud Kubernetes platform such as AWS EKS or Azure AKS.
7. Add monitoring with Prometheus and Grafana.

## Core Technologies

- Node.js / Express
- Docker
- Kubernetes
- Minikube
- NGINX Ingress Controller
- GitHub Actions
- AWS or Azure for production-style cloud deployment
- Prometheus and Grafana for monitoring

## Application Endpoints

- `/` - home page
- `/products` - product listing
- `/products/:id` - product detail
- `/cart` - simulated cart
- `/checkout` - simulated checkout
- `/health` - liveness endpoint
- `/ready` - readiness endpoint
- `/version` - deployment/version metadata
- `/metrics` - Prometheus metrics

## Blue-Green Deployment Strategy

- Blue is the current stable environment.
- Green is the new release candidate.
- Green is deployed and validated before traffic is switched.
- NGINX Ingress controls which service receives live traffic.
- Rollback is performed by switching the Ingress backend back to the previous stable service.

## Current Status

- Phase 1: Local application completed.
- Phase 2: Docker image completed.
- Phase 3: Git baseline in progress.
