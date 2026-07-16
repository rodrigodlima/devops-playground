# Argo CD

GitOps continuous delivery for the IDP. Argo CD watches Git repos and reconciles
the cluster to match the declared state — the delivery layer that ships both the
platform components and the applications developers scaffold from Backstage.

## Install Argo CD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

This installs the non-HA manifest — fine for local clusters and POCs. For a
production cluster use `ha/install.yaml` or the
[Helm chart](https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd).

Wait for the pods to come up:

```bash
kubectl wait --for=condition=available --timeout=300s \
  deployment --all -n argocd
```

View the installed Argo CD pods:

```bash
$ kubectl get pods -n argocd
NAME                                                READY   STATUS    RESTARTS   AGE
argocd-application-controller-0                     1/1     Running   0          2m
argocd-applicationset-controller-7d4bc4c5f7-x8k2p   1/1     Running   0          2m
argocd-dex-server-6b8c9f5d4-nk4wl                   1/1     Running   0          2m
argocd-notifications-controller-5c7f8d9b6-qm2vt     1/1     Running   0          2m
argocd-redis-7d9c8b5f4-tz6hn                        1/1     Running   0          2m
argocd-repo-server-6f5d8c7b9-w9p3k                  1/1     Running   0          2m
argocd-server-5b9f7c8d6-h2xnr                       1/1     Running   0          2m
```

## Install the Argo CD CLI

```bash
# macOS
brew install argocd
```

Other platforms: see the [CLI installation docs](https://argo-cd.readthedocs.io/en/stable/cli_installation/).

## Access the UI

The `argocd-server` Service is `ClusterIP` by default. Port-forward to reach it:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
# open https://localhost:8080
```

The certificate is self-signed, so the browser will warn — expected for a local
install.

## Get the initial admin password

Argo CD generates an initial password for the `admin` user and stores it in a
Secret:

```bash
argocd admin initial-password -n argocd
```

Or read the Secret directly:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

Log in with the CLI:

```bash
argocd login localhost:8080 --username admin
```

Change the password, then delete the bootstrap Secret — it is only meant for
first login:

```bash
argocd account update-password
kubectl -n argocd delete secret argocd-initial-admin-secret
```

## Register an application

Point Argo CD at a Git repo path holding Kubernetes manifests. Example, managing
the Backstage manifests in this repo:

```bash
argocd app create backstage \
  --repo https://github.com/rodrigodlima/devops-playground.git \
  --path platform \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace backstage
```

Sync it:

```bash
argocd app sync backstage
argocd app get backstage
```

### Declarative alternative

Prefer defining Applications as manifests so Argo CD itself is managed by GitOps:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: backstage
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/rodrigodlima/devops-playground.git
    targetRevision: main
    path: platform
  destination:
    server: https://kubernetes.default.svc
    namespace: backstage
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

Apply with `kubectl apply -f <file> -n argocd`.

## Notes

- The default install has **no ingress and no TLS termination**. Add an Ingress
  or Gateway before exposing it outside the cluster.
- The `admin` account is for bootstrap only. Wire up SSO (Dex / OIDC) and disable
  the local admin for anything shared.
- `syncPolicy.automated.prune: true` lets Argo CD **delete** resources that
  disappear from Git. Leave it off until you trust the repo contents.

## References

- [Argo CD — Getting Started](https://argo-cd.readthedocs.io/en/stable/getting_started/)
- [Declarative Setup](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/)
- [Argo CD Best Practices](https://argo-cd.readthedocs.io/en/stable/user-guide/best_practices/)
