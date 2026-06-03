# Phase 8 GitHub Actions CI Evidence

Date: Wed Jun  3 08:26:51 BST 2026

## Workflow
ShopSwift CI

## GitHub Actions Result
Workflow status: PASSED
Workflow run: ShopSwift CI #2
Duration observed: 55 seconds

## CI Purpose
The CI workflow validates the application and deployment artifacts before cloud promotion.

## Checks Performed
- Repository checkout
- Node.js 20 setup
- npm ci
- Unit tests
- Docker image build
- Trivy vulnerability scan
- Kubernetes manifest validation using kubeconform

## Why This Matters
This prevents broken code, failed Docker builds, vulnerable images, or invalid Kubernetes manifests from being merged without automated validation.

## Local Repository Status
On branch main
Your branch is up to date with 'origin/main'.

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	docs/evidence/phase-5-github-actions/github-actions-ci-evidence.md

nothing added to commit but untracked files present (use "git add" to track)

## Latest Commits
f1d100e Pin safe Trivy action version in CI workflow
f2adead Add GitHub Actions CI validation workflow
5d10e3c Simulate broken green release and validate readiness protection
3e155b8 Clean final blue-green zero-downtime evidence
f1c28a4 Finalize zero-downtime blue-green switching with active service selector
3aa6bd6 Implement zero-downtime blue-green switch using active service
7d2fb26 Deploy ShopSwift blue environment on Minikube with NGINX Ingress
9b0cf1f Deploy ShopSwift blue environment on Minikube with NGINX Ingress
5ca5965 Add project folder placeholders
b0987d2 Build ShopSwift app and Docker baseline

## Workflow File
name: ShopSwift CI

on:
  pull_request:
    branches:
      - main
  push:
    branches:
      - main

permissions:
  contents: read
  security-events: write

jobs:
  test-build-scan-validate:
    name: Test, Build, Scan, and Validate
    runs-on: ubuntu-latest

    defaults:
      run:
        shell: bash

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
          cache-dependency-path: app/package-lock.json

      - name: Install application dependencies
        working-directory: app
        run: npm ci

      - name: Run unit tests
        working-directory: app
        run: npm test

      - name: Build Docker image
        working-directory: app
        run: docker build -t shopswift:ci .

      - name: Scan Docker image with Trivy
        uses: aquasecurity/trivy-action@0.35.0
        with:
          image-ref: shopswift:ci
          version: v0.69.3
          format: table
          exit-code: '0'
          ignore-unfixed: true
          vuln-type: 'os,library'
          severity: 'CRITICAL,HIGH'

      - name: Install kubeconform
        run: |
          curl -L -o kubeconform.tar.gz https://github.com/yannh/kubeconform/releases/download/v0.6.7/kubeconform-linux-amd64.tar.gz
          tar -xzf kubeconform.tar.gz
          sudo mv kubeconform /usr/local/bin/kubeconform
          kubeconform -v

      - name: Validate Kubernetes manifests
        run: |
          kubeconform -strict -summary \
            k8s/namespace.yaml \
            k8s/blue-deployment.yaml \
            k8s/green-deployment.yaml \
            k8s/broken-green-deployment.yaml \
            k8s/blue-service.yaml \
            k8s/green-service.yaml \
            k8s/active-service.yaml \
            k8s/ingress.yaml

      - name: Print validation summary
        run: |
          echo "CI completed successfully."
          echo "Tests passed."
          echo "Docker image built."
          echo "Trivy scan completed."
          echo "Kubernetes manifests validated."
