#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${1:-http://localhost:3000}"
DURATION_SECONDS="${2:-30}"

echo "Testing availability for $DURATION_SECONDS seconds against $BASE_URL/version"

end_time=$((SECONDS + DURATION_SECONDS))
failures=0
requests=0

while [ $SECONDS -lt $end_time ]; do
  status_code=$(curl -s -o /tmp/shopswift-version.txt -w "%{http_code}" "$BASE_URL/version" || echo "000")
  requests=$((requests + 1))

  if [[ "$status_code" != "200" ]]; then
    failures=$((failures + 1))
    echo "FAILED request: status=$status_code"
  else
    version=$(cat /tmp/shopswift-version.txt | jq -r '.environment + " " + .version' 2>/dev/null || echo "unknown")
    echo "OK: $status_code $version"
  fi

  sleep 1
done

echo "Total requests: $requests"
echo "Failed requests: $failures"

if [[ "$failures" -gt 0 ]]; then
  exit 1
fi

echo "Zero-downtime availability test passed."
