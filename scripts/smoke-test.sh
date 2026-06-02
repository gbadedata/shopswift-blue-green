#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${1:-http://localhost:3000}"

echo "Running smoke tests against: $BASE_URL"

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
  status_code=$(curl -s -o /tmp/shopswift-response.txt -w "%{http_code}" "$BASE_URL$endpoint")

  if [[ "$status_code" != "200" ]]; then
    echo "FAILED: $endpoint returned $status_code"
    cat /tmp/shopswift-response.txt
    exit 1
  fi

  echo "PASSED: $endpoint returned $status_code"
done

echo "All smoke tests passed."
