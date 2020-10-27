<#
.SYNOPSIS
Removes the namespace resource.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroupName
The resource group the namespace is in.

.PARAMETER namespace.
The name of the namespace.

.EXAMPLE
.\Remove-Namespace-ServiceBus.ps1 -namespace "sb-aimmsgbox-dev-uksouth" -resourceGroupName "rg-aimapp-systemapplication-dev-uksouth"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $namespace
)

$resourceExists = az servicebus namespace list --resource-group $resourceGroupName --query "[?name=='$namespace'].{name:name}" -o tsv

if ($resourceExists) {
    Write-Host "Removing the namespace resource: $namespace"

    az servicebus namespace delete --name $namespace --resource-group $resourceGroupName
    
    Write-Host "Removed the namespace resource: $namespace"
}
else {
    Write-Host "The namespace resource $namespace does not exist in resource group $resourceGroupName"
}