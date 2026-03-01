# Trivy custom checks

Reference: https://trivy.dev/latest/docs/scanner/misconfiguration/custom/

## Why use custom checks?

Trivy has a large set of built-in rules, but organizations often need to enforce security policies that go beyond those defaults. Custom checks let you extend Trivy with your own rules to cover organization-specific requirements, proprietary standards, or compliance controls.

For example, detecting a hardcoded password in a specific Terraform resource attribute (like `aws_db_instance.password`) may not be covered by a built-in rule. A custom check lets you flag that precisely.

## Types of custom checks

This repo demonstrates two different extensibility mechanisms in Trivy:

### 1. Rego-based misconfiguration checks (`rds_hardcoded_password.rego`)

Written in [Rego](https://www.openpolicyagent.org/docs/latest/policy-language/) (OPA's policy language), these checks are used for **IaC misconfiguration scanning** (Terraform, CloudFormation, Kubernetes, Dockerfiles, etc.).

Run with:
```bash
trivy fs --scanners misconfig \
  --config-check ./rds_hardcoded_password.rego \
  --namespaces user \
  <path-to-terraform-code>
```

### 2. YAML-based secret scanning rules (`trivy-secret.yaml`)

These are custom **regex-based rules** for Trivy's secret scanner. They extend the built-in secret detection patterns with your own patterns.

Run with:
```bash
trivy fs --scanners secret \
  --secret-config ./trivy-secret.yaml \
  <path-to-scan>
```

To test against the Python example:
```bash
trivy fs --scanners secret \
  --secret-config ./trivy-secret.yaml \
  ../python-code-example/
```
