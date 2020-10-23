<#
.SYNOPSIS
Removes the topic channel resource.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroupName
The resource group name.

.PARAMETER namespace
The name of the namespace the topic is on.

.PARAMETER topic.
The topic to remove.

.EXAMPLE
.\Remove-TopicChannel-ServiceBus.ps1 -$resourceName "sb-aimmsgbox-dev-uksouth" -resourceGroupName "rg-aimapp-systemapplication-dev-uksouth" -topic "messagebox"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $namespace,
    [parameter(Mandatory = $true)]
    [string] $topic
)

$namespaceResourceExists = az servicebus namespace list --resource-group $resourceGroupName --query "[?name=='$namespace'].{name:name}" -o tsv

if ($namespaceResourceExists) {

    $topicResourceExists = az servicebus topic list --resource-group $resourceGroupName --namespace-name $namespace --query "[?name=='$topic'].{name:name}" -o tsv
 
    if ($topicResourceExists) {

        Write-Host "Removing the topic resource: $topic"

        az servicebus topic delete --resource-group $resourceGroupName --namespace-name $namespace --name $topic

        Write-Host "Removed the topic resource: $topic"
    }
    else {
        Write-Host "The topic resource $topic does not exist in resource group $resourceGroupName with the namespace $namespace"
    }
}
else {
    Write-Host "The namespace $namespace does not exist in resource group $resourceGroupName when attempting to remove the topic $topic"
}