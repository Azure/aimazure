<#
.SYNOPSIS
Tears down the artifact staore.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER integrationAccountName
The name of the artifact store to remove.

.PARAMETER resourceGroupName
The resource group the artifact store was deployed to.

.EXAMPLE
Remove-ArtifactStore.ps1 -integrationAccountName "intacc-aimartifactstore-dev-uksouth" -resourceGroupName "rg-aimmsgbus-dev-uksouth"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $integrationAccountName,
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName
)

Write-Host "Removing the integration account: $integrationAccountName"

az resource delete --resource-group $resourceGroupName --name $integrationAccountName --resource-type "Microsoft.Logic/IntegrationAccounts"

Write-Host "Removed the integration account: $integrationAccountName"