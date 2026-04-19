# GitHub Actions Mixed Runner Fleet — Best Practice Guide

## When to Use Which Runner Type

---

## 🏢 On-Prem Self-Hosted Runners

**USE WHEN:**
- Data **cannot leave your network** (regulatory: SOX, HIPAA, PCI-DSS, GDPR)
- Workloads require access to **private databases, internal APIs, or legacy systems** not reachable from the cloud
- You need **full audit trail** over build infrastructure for compliance
- Building **legacy applications** that depend on proprietary OS, hardware, or licensed tooling installed on specific machines
- Air-gapped or classified environments

**AVOID WHEN:**
- Workload has no compliance or network restrictions — you take on unnecessary ops burden
- You need elastic scale (on-prem is fixed capacity)

**SECURITY ESSENTIALS:**
- Never use on public repositories
- Enable `--ephemeral` mode to destroy runner state after each job
- Network segmentation — isolate runner subnet from general corporate network
- CIS-benchmark the host OS; automate patching
- Forward audit logs to your SIEM
- Use dedicated runner groups to restrict which repos can target these runners

---

## ☸️ AKS Runners (Actions Runner Controller)

**USE WHEN:**
- Jobs need **GPU, high-memory, or specialized compute** (AI/ML training, data processing)
- You need **elastic autoscaling** — burst to many runners during peak, scale-to-zero at idle
- Workloads are **container-compatible** and benefit from Kubernetes orchestration
- Data-heavy pipelines where **persistent caching** (Azure Files) speeds up builds
- You want cloud-native runner management without GitHub-hosted limitations

**AVOID WHEN:**
- The workload can't run in a container (bare-metal or proprietary OS dependency)
- Your team lacks Kubernetes operational expertise and doesn't want to invest in it
- Simple CI jobs that don't need elastic scale

**SECURITY ESSENTIALS:**
- Use GitHub App authentication (not PATs) for ARC registration
- Dedicated Kubernetes namespace with strict RBAC
- Pod Security Standards (restricted profile)
- Azure CNI + network policies for pod-level isolation
- Scan runner container images for vulnerabilities
- Use Azure Key Vault for secrets injection (not environment variables)

**SETUP QUICK START:**
```bash
# 1. Create AKS cluster
az aks create -g myRG -n arc-cluster --node-count 2 --generate-ssh-keys

# 2. Install Actions Runner Controller via Helm
helm install arc \
  --namespace arc-systems --create-namespace \
  oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller

# 3. Deploy a runner scale set
helm install my-runners \
  --namespace arc-runners --create-namespace \
  --set githubConfigUrl="https://github.com/YOUR-ORG" \
  --set githubConfigSecret.github_token="YOUR-TOKEN" \
  oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set
```

---

## ☁️ GitHub-Hosted Runners

**USE WHEN:**
- Standard CI/CD: linting, unit tests, packaging, publishing
- **Bursty, short-lived jobs** where you don't want to manage infrastructure
- Open-source projects or low-sensitivity workloads
- You want **zero maintenance** — always patched, always available
- Multi-platform testing (Linux, Windows, macOS in one workflow)

**AVOID WHEN:**
- Data must stay on-prem or within your Azure tenant
- Jobs need GPU or specialized hardware not available on hosted runners
- Build requires access to private network resources (unless using VNet integration)

**SECURITY ESSENTIALS:**
- Pin third-party actions to commit SHAs (not tags)
- Use OIDC for cloud credential exchange — no static secrets
- Set minimum `GITHUB_TOKEN` permissions in workflow YAML
- Enable private VNet integration for internal resource access
- Use required workflows / rulesets for organizational policy gates

---

## Decision Flowchart

```
                 ┌─────────────────────────────┐
                 │  Does data/compliance require │
                 │  on-prem execution?           │
                 └──────────┬──────────────────┘
                    YES ╱         ╲ NO
                       ╱           ╲
           ┌──────────▼───┐   ┌────▼──────────────────────┐
           │ 🏢 ON-PREM   │   │ Need GPU, auto-scale,     │
           │ Self-Hosted   │   │ or large compute?          │
           └───────────────┘   └──────┬─────────────────────┘
                                 YES ╱         ╲ NO
                                    ╱           ╲
                        ┌──────────▼───┐   ┌────▼──────────────┐
                        │ ☸️ AKS Runner │   │ ☁️ GitHub-Hosted  │
                        │ (via ARC)     │   │ Runner             │
                        └───────────────┘   └───────────────────┘
```

---

## Sample Multi-Runner Workflow

```yaml
name: mixed-runner-fleet
on: [push]

jobs:
  lint-and-test:                        # ☁️ Bursty, commodity job
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci && npm test

  build-secure-artifact:                # 🏢 Sensitive / legacy workload
    runs-on: [self-hosted, onprem, linux]
    needs: lint-and-test
    steps:
      - uses: actions/checkout@v4
      - run: ./build.sh --sign --audit

  train-ml-model:                       # ☸️ Elastic, GPU-heavy workload
    runs-on: [self-hosted, aks, gpu]
    needs: lint-and-test
    steps:
      - uses: actions/checkout@v4
      - run: python train.py --epochs 50
```

---

## Label Taxonomy Recommendation

| Label            | Meaning                                | Example `runs-on`                    |
|------------------|----------------------------------------|--------------------------------------|
| `self-hosted`    | Any self-managed runner                | `[self-hosted]`                      |
| `onprem`         | On-premises data center                | `[self-hosted, onprem, linux]`       |
| `aks`            | AKS-hosted via ARC                     | `[self-hosted, aks]`                 |
| `gpu`            | GPU-equipped node                      | `[self-hosted, aks, gpu]`            |
| `high-memory`    | 64GB+ RAM node                         | `[self-hosted, aks, high-memory]`    |
| `linux` / `windows` | OS type                             | `[self-hosted, onprem, windows]`     |
| `sensitive`      | Compliance-restricted runner group     | `[self-hosted, onprem, sensitive]`   |

---

## Documentation Links

### Core GitHub Docs
- **Runners Overview**: https://docs.github.com/en/actions/concepts/runners
- **Self-Hosted Runners Reference**: https://docs.github.com/actions/reference/runners/self-hosted-runners
- **Self-Hosted Runners Concepts**: https://docs.github.com/en/actions/concepts/runners/self-hosted-runners
- **GitHub-Hosted Runner Specs**: https://docs.github.com/en/actions/using-github-hosted-runners
- **Security Hardening Guide**: https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions

### AKS & Actions Runner Controller
- **ARC on AKS (Microsoft Learn)**: https://learn.microsoft.com/en-us/azure/aks/github-actions-azure-files-overview
- **ARC Quick Start**: https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller
- **ARC Helm Charts**: https://github.com/actions/actions-runner-controller

### Decision Guides & Blogs
- **GitHub Blog: When to Choose Hosted vs Self-Hosted**: https://github.blog/enterprise-software/ci-cd/when-to-choose-github-hosted-runners-or-self-hosted-runners-with-github-actions/
- **Enterprise Runner Management**: https://docs.github.com/en/enterprise-cloud@latest/admin/managing-github-actions-for-your-enterprise
- **GitHub Actions Security Cheat Sheet**: https://blog.gitguardian.com/github-actions-security-cheat-sheet/

---

## Cost Optimization Tips

| Strategy | Runner Type | Benefit |
|----------|------------|---------|
| Scale-to-zero with ARC | AKS | Pay only when jobs are running |
| Spot/low-priority VMs for AKS nodes | AKS | Up to 80% cost reduction for interruptible workloads |
| GitHub-hosted for short jobs (<10 min) | GitHub-Hosted | Per-minute billing, no idle cost |
| Reserve on-prem for must-stay-local only | On-Prem | Don't over-invest in CapEx |
| Cache dependencies (Azure Files / actions/cache) | All | Reduce build time = reduce cost |

---

*Generated March 2026 • GitHub Actions Mixed Runner Fleet Best Practice Guide*
