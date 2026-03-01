# Kubernetes Cluster Scanning

Scans a live cluster — nodes, pods, RBAC, and running images.

```trivy k8s --report summary name_of_cluster```
```trivy k8s --report all name_of_cluster```

# Kubernetes check yaml files

To scan a Kubernetes YAML file for misconfigurations using Trivy, use the trivy fs (filesystem) command and specify the file path. Trivy automatically identifies Kubernetes files and scans them with built-in checks.

```trivy fs *.yaml```