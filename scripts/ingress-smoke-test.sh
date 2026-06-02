#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${1:-http://localhost:8080}"
HOST_HEADER="${2:-shopswift.local}"

echo "Running Ingress smoke tests against: $BASE_URL"
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
  status_code=$(curl -s -H "Host: $HOST_HEADER" -o /tmp/shopswift-ingress-response.txt -w "%{http_code}" "$BASE_URL$endpoint")

  if [[ "$status_code" != "200" ]]; then
    echo "FAILED: $endpoint returned $status_code"
    cat /tmp/shopswift-ingress-response.txt
    exit 1
  fi

  echo "PASSED: $endpoint returned $status_code"
done

echo "All Ingress smoke tests passed."
