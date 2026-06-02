#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="ecommerce-bluegreen"
INGRESS_NAME="shopswift-ingress"
TARGET_SERVICE="shopswift-blue-service"

echo "Switching NGINX Ingress traffic to Blue..."

kubectl patch ingress "$INGRESS_NAME" \
  -n "$NAMESPACE" \
  --type=json \
  -p="[{\"op\":\"replace\",\"path\":\"/spec/rules/0/http/paths/0/backend/service/name\",\"value\":\"$TARGET_SERVICE\"}]"

echo "Ingress now points to $TARGET_SERVICE"
kubectl get ingress "$INGRESS_NAME" -n "$NAMESPACE"
