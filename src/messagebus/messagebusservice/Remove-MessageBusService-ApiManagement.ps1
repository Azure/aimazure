<#
.SYNOPSIS
Tears down the App Insights resource.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroup
The name of the resource group containing the resources to remove.

.PARAMETER resourceName
The name of the resource to remove.

.EXAMPLE
./Remove-MessageBusService-ApiManagement.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth" -resourceName "apim-aimmsgbussvc-dev"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $resourceName
)

$resourceExists = az apim show --name $resourceName --resource-group $resourceGroupName

# Reset console colour because the show command breaks the colours and outputs black on black
[Console]::ResetColor()

if ($resourceExists) {
    Write-Host "Removing the API management resource: $resourceName"

    az apim delete --name $resourceName --resource-group $resourceGroupName --yes

    Write-Host "Removed the API management resource: $resourceName"
}
else {
    Write-Host "The API management resource $resourceName does not exist in resource group $resourceGroupName"
}
