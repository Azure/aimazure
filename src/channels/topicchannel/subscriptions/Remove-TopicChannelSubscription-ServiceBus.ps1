<#
.SYNOPSIS
Removes a topic subscription.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroupName
Name of the resource group where the resources will be deleted.

.PARAMETER name
Name of the subscription that will be deleted.

.PARAMETER serviceBusNamespace
Name of the Azure Service Bus namespace.

.PARAMETER serviceBusTopic
Name of the Azure Service Bus topic.

.EXAMPLE
./Remove-TopicChannelSubscription-ServiceBus.ps1 -resourceGroupName "rg-aimapp-app1-dev-uksouth" -resourceName "sbs-aimmsgbox-ftp-passthru" -serviceBusNamespace "sb-aimmsgbox-dev-uksouth" -serviceBusTopic "messagebox"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $resourceName,
    [parameter(Mandatory = $true)]
    [string] $serviceBusNamespace,
    [parameter(Mandatory = $true)]
    [string] $serviceBusTopic
)

$resourceExists = az servicebus topic subscription show --name $resourceName --resource-group $resourceGroupName --namespace-name $serviceBusNamespace --topic-name $serviceBusTopic

if ($resourceExists) {
    Write-Host "Removing the topic subscription resource: $resourceName"

    az servicebus topic subscription delete --name $resourceName --resource-group $resourceGroupName --namespace-name $serviceBusNamespace --topic-name $serviceBusTopic

    Write-Host "Removed the topic subscription resource: $resourceName"
}
else {
    Write-Host "The topic subscription resource $resourceName does not exist in resource group $resourceGroupName"
}
