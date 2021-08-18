<#
.SYNOPSIS
Tears down the event grid subscribe api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroup
The name of the resource group containing the resources to remove.

.PARAMETER resourceName
The name of the resource to remove.

.EXAMPLE
.\Remove-EventGridSubscribe-ApiConnection.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth-xxxxx" -resourceName "apic-eventgridsubscribe-dev-xxxxx"
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
    Write-Host "Removing the event grid subscribe api connection resource: $resourceName"

    az resource delete --name $resourceName --resource-group $resourceGroupName --resource-type "connections" --namespace "Microsoft.Web"

    Write-Host "Removed the event grid subscribe api connection resource: $resourceName"
}
else {
    Write-Host "The event grid subscribe api connection resource $resourceName does not exist in resource group $resourceGroupName"
}