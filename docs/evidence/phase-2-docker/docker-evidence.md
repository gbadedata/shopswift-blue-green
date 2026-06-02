# Phase 2 Docker Evidence

Date: Tue Jun  2 22:53:40 BST 2026

## Docker Version
Docker version 29.1.3, build 29.1.3-0ubuntu3~24.04.2

## Docker Images
shopswift:v1.0.0                                                                                      5186f6f4dec4        207MB         50.5MB   U    

## Running Containers
dfa5b2bb588e   shopswift:v1.0.0                      "docker-entrypoint.s…"   4 minutes ago    Up 4 minutes    0.0.0.0:3000->3000/tcp, [::]:3000->3000/tcp                                                                                            shopswift-test

## Endpoint Checks
{"status":"healthy"}
{"status":"ready"}
{"app":"ShopSwift","version":"v1.0.0","environment":"blue","commit":"local-docker","port":3000,"status":"running"}

## Smoke Test
Running smoke tests against: http://localhost:3000
PASSED: / returned 200
PASSED: /health returned 200
PASSED: /ready returned 200
PASSED: /version returned 200
PASSED: /products returned 200
PASSED: /cart returned 200
PASSED: /checkout returned 200
All smoke tests passed.

## Short Availability Test
Testing availability for 10 seconds against http://localhost:3000/version
OK: 200 blue v1.0.0
OK: 200 blue v1.0.0
OK: 200 blue v1.0.0
OK: 200 blue v1.0.0
OK: 200 blue v1.0.0
OK: 200 blue v1.0.0
OK: 200 blue v1.0.0
OK: 200 blue v1.0.0
OK: 200 blue v1.0.0
Total requests: 9
Failed requests: 0
Zero-downtime availability test passed.
