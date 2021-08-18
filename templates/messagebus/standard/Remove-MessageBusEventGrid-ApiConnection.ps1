<#
.SYNOPSIS
Tears down the message bus event grid api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroup
The name of the resource group containing the resources to remove.

.PARAMETER resourceName
The name of the resource to remove.

.EXAMPLE
.\Remove-MessageBusEventGrid-ApiConnection.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth-xxxxx" -resourceName "apic-messagebuseventgrid-dev-xxxxx"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $resourceName
)

$resourceExists = az resource show --name $resourceName --resource-group $resourceGroupName --resource-type "connections" --namespace "Microsoft.Web"

if ($resourceExists) {
    Write-Host "Removing the message bus event grid api connection resource: $resourceName"

    az resource delete --name $resourceName --resource-group $resourceGroupName --resource-type "connections" --namespace "Microsoft.Web"

    Write-Host "Removed the message bus event grid api connection resource: $resourceName"
}
else {
    Write-Host "The message bus event grid api connection resource $resourceName does not exist in resource group $resourceGroupName"
}