<#
.SYNOPSIS
Tears down the Function resource.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroup
The name of the resource group containing the resources to remove.

.PARAMETER resourceName
The name of the resource to remove.

.EXAMPLE
./Remove-MessagingManager-Function.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth" -resourceName "func-aimmsgmgr-dev-001"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $resourceName
)

$resourceExists = az functionapp show --name $resourceName --resource-group $resourceGroupName

if ($resourceExists) {
    Write-Host "Removing the messaging manager function resource: $resourceName"

    az functionapp delete --name $resourceName --resource-group $resourceGroupName

    Write-Host "Removed the messaging manager function resource: $resourceName"
}
else {
    Write-Host "The messaging manager function resource $resourceName does not exist in resource group $resourceGroupName"
}
