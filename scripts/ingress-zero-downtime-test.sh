#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${1:-http://localhost:8080}"
HOST_HEADER="${2:-shopswift.local}"
DURATION_SECONDS="${3:-30}"

echo "Testing Ingress availability for $DURATION_SECONDS seconds"
echo "URL: $BASE_URL/version"
echo "Host header: $HOST_HEADER"

end_time=$((SECONDS + DURATION_SECONDS))
failures=0
requests=0

while [ $SECONDS -lt $end_time ]; do
  status_code=$(curl -s -H "Host: $HOST_HEADER" -o /tmp/shopswift-ingress-version.txt -w "%{http_code}" "$BASE_URL/version" || echo "000")
  requests=$((requests + 1))

  if [[ "$status_code" != "200" ]]; then
    failures=$((failures + 1))
    echo "FAILED request: status=$status_code"
  else
    version=$(cat /tmp/shopswift-ingress-version.txt | jq -r '.environment + " " + .version' 2>/dev/null || echo "unknown")
    echo "OK: $status_code $version"
  fi

  sleep 1
done

echo "Total requests: $requests"
echo "Failed requests: $failures"

if [[ "$failures" -gt 0 ]]; then
  exit 1
fi

echo "Ingress zero-downtime availability test passed."
