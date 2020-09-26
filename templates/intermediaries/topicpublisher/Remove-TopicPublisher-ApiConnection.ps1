<#
.SYNOPSIS
Tears down the api connection for the topic publisher.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroup
The name of the resource group containing the resources to remove.

.PARAMETER resourceName
The name of the resource to remove.

.EXAMPLE
.\Remove-TopicPublisher.ApiConnection.ps1 -resourceGroupName "sb-aimmsgbox-dev-uksouth-xxxxx" -resourceName "Aim-TopicPublisher-Channel"
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
    Write-Host "Removing the topic publisher api connection resource: $resourceName"

    az resource delete --name $resourceName --resource-group $resourceGroupName --resource-type "connections" --namespace "Microsoft.Web"

    Write-Host "Removed the topic publisher api connection resource: $resourceName"
}
else {
    Write-Host "The topic publisher api connection resource $resourceName does not exist in resource group $resourceGroupName"
}
