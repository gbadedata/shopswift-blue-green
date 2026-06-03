# Phase 10 Monitoring Screenshot Evidence Index

## Prometheus Evidence

- `prometheus-target-health.jpeg` — Prometheus target health page showing monitored targets.
- `prometheus-query-up.jpeg` — Prometheus `up` query showing active scrape targets.
- `prometheus-query-kube-pod-info-ecommerce-bluegreen.jpeg` — Prometheus query showing ShopSwift pods in the ecommerce-bluegreen namespace.
- `prometheus-query-deployment-replicas-available.jpeg` — Prometheus query showing available Blue and Green deployment replicas.
- `prometheus-query-container-cpu-usage-ecommerce-bluegreen.jpeg` — Prometheus query showing container CPU metrics for ShopSwift workloads.

## Grafana Evidence

- `grafana-ecommerce-bluegreen-namespace-final.png` — Grafana namespace dashboard for the ShopSwift Blue-Green namespace.
- `grafana-shopswift-pods-visible-final.png` — Grafana dashboard showing ShopSwift Blue and Green pods.
- `grafana-ingress-nginx-namespace-final.png` — Grafana dashboard showing ingress-nginx namespace metrics.
- `grafana-monitoring-namespace-final.png` — Grafana dashboard showing monitoring namespace metrics.

## Summary Contact Sheets

- `monitoring-prometheus-evidence-contact-sheet.png`
- `monitoring-grafana-evidence-contact-sheet.png`

## Interpretation

These screenshots prove that Prometheus and Grafana were deployed on AWS EKS and used to observe Kubernetes workloads, namespaces, pods, NGINX Ingress, and the ShopSwift Blue-Green deployment.

They prove infrastructure and Kubernetes observability. They do not claim business-level observability such as order value, checkout conversion, or user analytics.
