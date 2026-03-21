# Azure Deploy Skill

## Description
Deploys applications to Azure using the Azure CLI and Azure Developer CLI (azd). Knows about Azure Container Apps, App Service, Static Web Apps, and Azure Functions.

## When to Use
- User asks to deploy to Azure
- User wants to set up CI/CD for Azure
- User needs to configure Azure resources
- User asks about Azure deployment best practices

## Knowledge

### Supported Azure Services
| Service | Best For | Scaling |
|---------|----------|---------|
| **Container Apps** | Microservices, APIs | Auto-scale to zero |
| **App Service** | Traditional web apps | Manual/auto scale |
| **Static Web Apps** | SPAs, static sites | Global CDN |
| **Functions** | Event-driven, serverless | Per-invocation |

### Deployment Commands
```bash
# Azure Developer CLI (recommended for new projects)
azd init          # Initialize project with Azure config
azd provision     # Create Azure resources
azd deploy        # Deploy application code
azd up            # provision + deploy in one step

# Azure CLI (for existing resources)
az containerapp up --source .     # Deploy to Container Apps
az webapp deploy --src-path .     # Deploy to App Service
az staticwebapp deploy            # Deploy to Static Web Apps
```

### Required Files
- `azure.yaml` — Azure Developer CLI project definition
- `infra/main.bicep` — Infrastructure as Code
- `.github/workflows/deploy.yml` — CI/CD pipeline

### Environment Variables
Always use Azure Key Vault or App Configuration for secrets:
```bash
az keyvault secret set --vault-name myVault --name "DbPassword" --value "$DB_PASS"
```

## References
- [Azure Developer CLI docs](https://learn.microsoft.com/azure/developer/azure-developer-cli/)
- [Container Apps docs](https://learn.microsoft.com/azure/container-apps/)
- [Bicep documentation](https://learn.microsoft.com/azure/azure-resource-manager/bicep/)
