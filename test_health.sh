#!/usr/bin/env bash
# Simple smoke test: curl the health endpoint and check for HTTP 200
set -e

URL="${1:-http://localhost:5000/health}"
echo "Checking $URL ..."

response=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

if [ "$response" -eq 200 ]; then
  echo "Health check PASSED (HTTP $response)"
  exit 0
else
  echo "Health check FAILED (HTTP $response)"
  exit 1
fi
