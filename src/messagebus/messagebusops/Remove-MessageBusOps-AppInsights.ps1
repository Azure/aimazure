<#
.SYNOPSIS
Tears down the API Management resource.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroup
The name of the resource group containing the resources to remove.

.PARAMETER resourceName
The name of the resource to remove.

.EXAMPLE
./Remove-MessageBusOps-AppInsights.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth" -resourceName "appi-aimmsgbusops-dev"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $resourceName
)

az extension add --name application-insights

$resourceExists = az monitor app-insights component show --app $resourceName --resource-group $resourceGroupName

if ($resourceExists) {
    Write-Host "Removing the App Insights resource: $resourceName"

    az monitor app-insights component delete --app $resourceName --resource-group $resourceGroupName

    Write-Host "Removed the App Insights resource: $resourceName"
}
else {
    Write-Host "The App Insights resource $resourceName does not exist in resource group $resourceGroupName"
}
