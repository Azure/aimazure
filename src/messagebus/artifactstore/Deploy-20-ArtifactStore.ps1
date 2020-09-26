<#
.SYNOPSIS
Invokes the deployment of an atrifact store.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
Deploy-20-ArtifactStore.ps1
#>

& $PSScriptRoot\New-ArtifactStore.ps1 -templateFile "$PSScriptRoot\artifactstore.json" -templateParameterFile "$PSScriptRoot\artifactstore.dev.parameters.json" -resourceGroup "rg-aimmsgbus-dev-uksouth" -deploymentName "messagebusservice.plan.uksouth.xxxxx"
