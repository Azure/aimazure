<#
.SYNOPSIS
Removes the topic channel resource.
.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.
.EXAMPLE
.\Remove-TopicChannel-ServiceBus.ps1 --$resourceName "sb-aimmsgbox-dev-uksouth" --resourceGroupName "rg-aimapp-systemapplication-dev-uksouth"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $resourceName
)

$resourceExists = az servicebus namespace list --resource-group $resourceGroupName --query "[?name=='$resourceName'].{name:name}" -o tsv

if ($resourceExists) {
    Write-Host "Removing the topic channel resource: $resourceName"

    az servicebus namespace delete --name $resourceName --resource-group $resourceGroupName
    
    Write-Host "Removed the topic channel resource: $resourceName"
}
else {
    Write-Host "The topic channel resource $resourceName does not exist in resource group $resourceGroupName"
}