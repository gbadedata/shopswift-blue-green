#!/usr/bin/env bash
set -euo pipefail

AWS_INGRESS_HOST="${1:?Usage: ./scripts/aws-ingress-smoke-test.sh <aws-load-balancer-host>}"
HOST_HEADER="${2:-shopswift.aws.local}"

BASE_URL="http://$AWS_INGRESS_HOST"

echo "Running AWS Ingress smoke tests against: $BASE_URL"
echo "Using Host header: $HOST_HEADER"

endpoints=(
  "/"
  "/health"
  "/ready"
  "/version"
  "/products"
  "/cart"
  "/checkout"
)

for endpoint in "${endpoints[@]}"; do
  status_code=$(curl -s -H "Host: $HOST_HEADER" -o /tmp/shopswift-aws-response.txt -w "%{http_code}" "$BASE_URL$endpoint")

  if [[ "$status_code" != "200" ]]; then
    echo "FAILED: $endpoint returned $status_code"
    cat /tmp/shopswift-aws-response.txt
    exit 1
  fi

  echo "PASSED: $endpoint returned $status_code"
done

echo "All AWS Ingress smoke tests passed."
