#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="ecommerce-bluegreen"
SERVICE_NAME="shopswift-active-service"

echo "Switching active Service selector to Blue..."

kubectl patch service "$SERVICE_NAME" \
  -n "$NAMESPACE" \
  --type='merge' \
  -p '{"spec":{"selector":{"app":"shopswift","environment":"blue"}}}'

echo "Active Service now routes to Blue."

echo ""
echo "Active Service selector:"
kubectl get service "$SERVICE_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.selector}'
echo ""

echo ""
echo "Active Service endpoints:"
kubectl get endpoints "$SERVICE_NAME" -n "$NAMESPACE"
