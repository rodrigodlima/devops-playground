# Internal Developer Platform (IDP)

A self-service Internal Developer Platform running on Kubernetes, built to explore how
[Backstage](https://backstage.io), [Crossplane](https://www.crossplane.io),
[Argo CD](https://argo-cd.readthedocs.io) and GitHub Actions fit together to give
developers golden paths for shipping software without needing to know the underlying
infrastructure.

## What is this?

An IDP provides a single, self-service entry point where developers can create,
deploy and manage software without dealing with the underlying platform complexity.
The pieces in this project map to the classic IDP layers:

| Layer | Tool | Role |
|-------|------|------|
| **Developer Portal** | Backstage | Service catalog, software templates, docs and the self-service UI |
| **Control Plane** | Crossplane | Provision cloud/infra resources declaratively from Kubernetes |
| **Continuous Delivery** | Argo CD | GitOps — reconcile cluster state from Git |
| **Continuous Integration** | GitHub Actions | Build, test and package application code |
| **Runtime** | Kubernetes | Where everything runs |

### High-level flow

```
Developer → Backstage (template) → Git repo (scaffolded)
                                       │
                          GitHub Actions (CI: build/test/image)
                                       │
                          Argo CD (GitOps sync) ──► Kubernetes
                                       │
                          Crossplane (provision infra: DB, buckets, etc.)
```

## Repository layout (`platform/`)

Kubernetes manifests to run Backstage backed by PostgreSQL:

| File | Purpose |
|------|---------|
| `namespace.yaml` | `backstage` namespace |
| `backstage.yaml` | Backstage Deployment (image `backstage:1.0.0`, port `7007`) |
| `backstage-service.yaml` | Service exposing Backstage on port `80` |
| `app-config.production.yaml` | Backstage production config (backend, CORS, Postgres) |
| `backstage-secrets.yaml` | Backend auth secret (`BACKEND_SECRET`) — POC only |
| `postgres.yaml` | PostgreSQL 13 Deployment |
| `postgres-service.yaml` | Service exposing Postgres on `5432` |
| `postgres-storage.yaml` | PersistentVolume + Claim (2Gi, `hostPath`) |
| `postgres-secrets.yaml` | Postgres credentials |

## Prerequisites

- A Kubernetes cluster (kind / minikube / k3d for local, or a managed cluster)
- `kubectl` configured against the cluster
- A Backstage image built and available to the cluster as `backstage:1.0.0`
  (see the [Backstage deployment docs](https://backstage.io/docs/deployment/k8s))

## Deploy Backstage

```bash
kubectl apply -f namespace.yaml

# secrets first
kubectl apply -f postgres-secrets.yaml
kubectl apply -f backstage-secrets.yaml

# postgres
kubectl apply -f postgres-storage.yaml
kubectl apply -f postgres.yaml
kubectl apply -f postgres-service.yaml

# backstage
kubectl create configmap backstage-app-config \
  --from-file=app-config.production.yaml -n backstage
kubectl apply -f backstage.yaml
kubectl apply -f backstage-service.yaml
```

Port-forward to reach the portal:

```bash
kubectl port-forward -n backstage svc/backstage 7007:80
# open http://localhost:7007
```

## Status

- [x] Backstage + PostgreSQL running on Kubernetes
- [x] Crossplane control plane + Compositions (self-service infra) - In progress
- [ ] Argo CD for GitOps delivery of platform + apps
- [ ] GitHub Actions CI pipelines wired to Backstage software templates
- [ ] Backstage software templates (golden paths)

## Notes

- Secrets in this repo are **POC placeholders**. Replace with a real secrets
  manager (e.g. External Secrets Operator, Sealed Secrets, Vault) before any
  real use.
- `postgres-storage.yaml` uses a `hostPath` PersistentVolume — fine for local
  clusters, not for production.

## Component docs

- [Argo CD](argocd.md) — install, access, register applications

## References

- [Backstage](https://backstage.io/docs)
- [Crossplane](https://docs.crossplane.io)
- [Argo CD](https://argo-cd.readthedocs.io)
- [What is an IDP? (CNCF)](https://tag-app-delivery.cncf.io/whitepapers/platforms/)

## Crossplane

### Install Crossplane
```
helm install crossplane \
--namespace crossplane-system \
--create-namespace crossplane-stable/crossplane
```

View the installed Crossplane pods with kubectl get pods -n crossplane-system

```
$ kubectl get pods -n crossplane-system
NAME                                       READY   STATUS    RESTARTS   AGE
crossplane-6d67f8cd9d-g2gjw                1/1     Running   0          26m
crossplane-rbac-manager-86d9b5cf9f-2vc4s   1/1     Running   0          26m
```