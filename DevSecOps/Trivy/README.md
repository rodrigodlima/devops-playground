# Trivy Scan

## Local Scan

You can scan your code locally with Trivy. There is an example in the script `trivy-scan-local-code.sh`.

## Remote Repository

You can scan code on a remote repository. There is an example in the script `trivy-scan-remote-repo.sh`.

# Example of IaC Code

We have a folder with a Terraform code example. A password was added to test if Trivy could detect it, but it can't out of the box. Trivy does not detect generic passwords, only AWS secrets, tokens, etc. So we need to create a custom rule for Trivy to detect it.

There is an example of this configuration in the `custom-checks` folder.

### Running Trivy with a Custom Rule

To scan your Terraform code using a custom secret rule, mount both the target code and the `custom-checks` folder into the container:

```bash
docker run --rm \
  -v $(pwd)/terraform-code-example:/scan \
  -v $(pwd)/custom-checks:/checks \
  trivy-scanner fs \
  --scanners secret \
  --secret-config /checks/trivy-secret.yaml \
  /scan
```

You can also combine multiple scanners to get a broader analysis:

```bash
docker run --rm \
  -v $(pwd)/terraform-code-example:/scan \
  -v $(pwd)/custom-checks:/checks \
  trivy-scanner fs \
  --scanners secret,misconfig \
  --secret-config /checks/trivy-secret.yaml \
  /scan
```

| Scanner                    | What it detects                       | Why it doesn't work for hardcoded passwords              |
|----------------------------|---------------------------------------|----------------------------------------------------------|
| `vuln`                     | CVEs in packages                      | Does not analyze IaC code                                |
| `secret` (built-in)        | Known patterns (AWS keys, tokens)     | `foobarbaz` is not a recognized pattern                  |
| `misconfig`                | Insecure configurations in IaC        | Cloud schema intentionally omits the `password` field    |
| `secret` + custom rule     | Any regex pattern                     | Works!                                                   |
# Vulnerable Dependencies (CVE detection)

To test vulnerability scan examples, I created a file python-code-example/requirements.txt with some old Python packages