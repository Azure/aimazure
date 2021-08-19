<#
.SYNOPSIS
Tears down the process manager service bus api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroup
The name of the resource group containing the resources to remove.

.PARAMETER resourceName
The name of the resource to remove.

.EXAMPLE
.\Remove-ProcessManagerServiceBus-ApiConnection.ps1 -resourceGroup "rg-aimapp-aim-ftppassthru-dev-uksouth-xxxxx" -resourceName "apic-aimsbconnector-processmanager-dev-xxxxx"
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
    Write-Host "Removing the process manager service bus api connection resource: $resourceName"

    az resource delete --name $resourceName --resource-group $resourceGroupName --resource-type "connections" --namespace "Microsoft.Web"

    Write-Host "Removed the process manager service bus api connection resource: $resourceName"
}
else {
    Write-Host "The process manager service bus api connection resource $resourceName does not exist in resource group $resourceGroupName"
}
