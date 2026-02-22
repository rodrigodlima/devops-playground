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

# How to test

docker run --rm -v $(pwd):/scan trivy-scanner fs --scanners vuln /scan

You should see something like that:

```
python-code-example/requirements.txt (pip)
==========================================
Total: 20 (UNKNOWN: 0, LOW: 2, MEDIUM: 5, HIGH: 10, CRITICAL: 3)

┌──────────┬─────────────────────┬──────────┬────────┬───────────────────┬───────────────┬──────────────────────────────────────────────────────────────┐
│ Library  │    Vulnerability    │ Severity │ Status │ Installed Version │ Fixed Version │                            Title                             │
├──────────┼─────────────────────┼──────────┼────────┼───────────────────┼───────────────┼──────────────────────────────────────────────────────────────┤
│ Pillow   │ CVE-2021-34552      │ CRITICAL │ fixed  │ 8.2.0             │ 8.3.0         │ python-pillow: Buffer overflow in image convert function     │
│          │                     │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2021-34552                   │
│          ├─────────────────────┤          │        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│          │ CVE-2022-22817      │          │        │                   │ 9.0.1         │ python-pillow: PIL.ImageMath.eval allows evaluation of       │
│          │                     │          │        │                   │               │ arbitrary expressions                                        │
│          │                     │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2022-22817                   │
│          ├─────────────────────┤          │        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│          │ CVE-2023-50447      │          │        │                   │ 10.2.0        │ pillow: Arbitrary Code Execution via the environment         │
│          │                     │          │        │                   │               │ parameter                                                    │
│          │                     │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2023-50447                   │
│          ├─────────────────────┼──────────┤        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│          │ CVE-2021-23437      │ HIGH     │        │                   │ 8.3.2         │ python-pillow: possible ReDoS via the getrgb function        │
│          │                     │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2021-23437                   │
│          ├─────────────────────┤          │        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│          │ CVE-2022-24303      │          │        │                   │ 9.0.1         │ python-pillow: temporary directory with a space character    │
│          │                     │          │        │                   │               │ allows removal of unrelated file...                          │
│          │                     │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2022-24303                   │
│          ├─────────────────────┤          │        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│          │ CVE-2022-45198      │          │        │                   │ 9.2.0         │ Pillow before 9.2.0 performs Improper Handling of Highly     │
│          │                     │          │        │                   │               │ Compressed GI ...                                            │
│          │                     │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2022-45198                   │
│          ├─────────────────────┤          │        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│          │ CVE-2023-44271      │          │        │                   │ 10.0.0        │ python-pillow: uncontrolled resource consumption when        │
│          │                     │          │        │                   │               │ textlength in an ImageDraw instance operates on...           │
│          │                     │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2023-44271                   │
│          ├─────────────────────┤          │        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│          │ CVE-2023-4863       │          │        │                   │ 10.0.1        │ libwebp: Heap buffer overflow in WebP Codec                  │
│          │                     │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2023-4863                    │
│          ├─────────────────────┤          │        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│          │ CVE-2024-28219      │          │        │                   │ 10.3.0        │ python-pillow: buffer overflow in _imagingcms.c              │
│          │                     │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2024-28219                   │
│          ├─────────────────────┼──────────┤        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│          │ CVE-2022-22815      │ MEDIUM   │        │                   │ 9.0.0         │ python-pillow: improperly initializes ImagePath.Path in      │
│          │                     │          │        │                   │               │ path_getbbox() in path.c                                     │
│          │                     │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2022-22815                   │
│          ├─────────────────────┤          │        │                   │               ├──────────────────────────────────────────────────────────────┤
│          │ CVE-2022-22816      │          │        │                   │               │ python-pillow: buffer over-read during initialization of     │
│          │                     │          │        │                   │               │ ImagePath.Path in path_getbbox() in path.c                   │
│          │                     │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2022-22816                   │
│          ├─────────────────────┼──────────┤        │                   │               ├──────────────────────────────────────────────────────────────┤
│          │ GHSA-4fx9-vc88-q2xc │ LOW      │        │                   │               │ Infinite loop in Pillow                                      │
│          │                     │          │        │                   │               │ https://github.com/advisories/GHSA-4fx9-vc88-q2xc            │
├──────────┼─────────────────────┼──────────┤        ├───────────────────┼───────────────┼──────────────────────────────────────────────────────────────┤
│ flask    │ CVE-2018-1000656    │ HIGH     │        │ 0.12.0            │ 0.12.3        │ python-flask: Denial of Service via crafted JSON file        │
│          │                     │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2018-1000656                 │
│          ├─────────────────────┤          │        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│          │ CVE-2019-1010083    │          │        │                   │ 1.0           │ python-flask: unexpected memory usage can lead to denial of  │
│          │                     │          │        │                   │               │ service via crafted...                                       │
│          │                     │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2019-1010083                 │
│          ├─────────────────────┤          │        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│          │ CVE-2023-30861      │          │        │                   │ 2.3.2, 2.2.5  │ flask: Possible disclosure of permanent session cookie due   │
│          │                     │          │        │                   │               │ to missing Vary: Cookie...                                   │
│          │                     │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2023-30861                   │
│          ├─────────────────────┼──────────┤        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│          │ CVE-2026-27205      │ LOW      │        │                   │ 3.1.3         │ Flask is a web server gateway interface (WSGI) web           │
│          │                     │          │        │                   │               │ application framewo ......                                   │
│          │                     │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2026-27205                   │
├──────────┼─────────────────────┼──────────┤        ├───────────────────┼───────────────┼──────────────────────────────────────────────────────────────┤
│ requests │ CVE-2018-18074      │ HIGH     │        │ 2.18.0            │ 2.20.0        │ python-requests: Redirect from HTTPS to HTTP does not remove │
│          │                     │          │        │                   │               │ Authorization header                                         │
│          │                     │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2018-18074                   │
│          ├─────────────────────┼──────────┤        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│          │ CVE-2023-32681      │ MEDIUM   │        │                   │ 2.31.0        │ python-requests: Unintended leak of Proxy-Authorization      │
│          │                     │          │        │                   │               │ header                                                       │
│          │                     │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2023-32681                   │
│          ├─────────────────────┤          │        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│          │ CVE-2024-35195      │          │        │                   │ 2.32.0        │ requests: subsequent requests to the same host ignore cert   │
│          │                     │          │        │                   │               │ verification                                                 │
│          │                     │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2024-35195                   │
│          ├─────────────────────┤          │        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│          │ CVE-2024-47081      │          │        │                   │ 2.32.4        │ requests: Requests vulnerable to .netrc credentials leak via │
│          │                     │          │        │                   │               │ malicious URLs                                               │
│          │                     │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2024-47081                   │
└──────────┴─────────────────────┴──────────┴────────┴───────────────────┴───────────────┴──────────────────────────────────────────────────────────────┘
```