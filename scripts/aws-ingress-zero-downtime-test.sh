#!/usr/bin/env bash
set -euo pipefail

AWS_INGRESS_HOST="${1:?Usage: ./scripts/aws-ingress-zero-downtime-test.sh <aws-load-balancer-host> [host-header] [duration-seconds]}"
HOST_HEADER="${2:-shopswift.aws.local}"
DURATION_SECONDS="${3:-30}"

BASE_URL="http://$AWS_INGRESS_HOST"

echo "Testing AWS Ingress availability for $DURATION_SECONDS seconds"
echo "URL: $BASE_URL/version"
echo "Host header: $HOST_HEADER"

end_time=$((SECONDS + DURATION_SECONDS))
failures=0
requests=0

while [ $SECONDS -lt $end_time ]; do
  status_code=$(curl -s -H "Host: $HOST_HEADER" -o /tmp/shopswift-aws-version.txt -w "%{http_code}" "$BASE_URL/version" || echo "000")
  requests=$((requests + 1))

  if [[ "$status_code" != "200" ]]; then
    failures=$((failures + 1))
    echo "FAILED request: status=$status_code"
  else
    version=$(cat /tmp/shopswift-aws-version.txt | jq -r '.environment + " " + .version' 2>/dev/null || echo "unknown")
    echo "OK: $status_code $version"
  fi

  sleep 1
done

echo "Total requests: $requests"
echo "Failed requests: $failures"

if [[ "$failures" -gt 0 ]]; then
  exit 1
fi

echo "AWS Ingress zero-downtime availability test passed."
