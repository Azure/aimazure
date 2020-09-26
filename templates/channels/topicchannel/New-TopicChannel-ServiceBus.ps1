<#
.SYNOPSIS
Creates an Topic Channel resource for use by various AIM components.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroupName
Name of the resource group where the resources will be created.

.PARAMETER location
The location to create the service bus in.

.PARAMETER namespace
Namespace to create the service bus with.

.PARAMETER sku
The SKU level for the namespace.

.PARAMETER topic
Topic name to create in the namespace.

.PARAMETER enablePartitioning
Defines if partitioning should be enabled (true) or not on the topic.

.PARAMETER tags
The tags to apply to the namespace.

.EXAMPLE
.\New-TopicChannel-ServiceBus.ps1 -resourceGroupName "rg-aimapp-systemapplication-dev-uksouth" -location "uksouth" -namespace "sb-aimmsgbox-dev-uksouth" -sku "Standard" -topic "messagebox"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $location,
    [parameter(Mandatory = $true)]
    [string] $namespace,
    [parameter(Mandatory = $false)]
    [string] $sku = "Basic",
    [parameter(Mandatory = $true)]
    [string] $topic,
    [parameter(Mandatory = $true)]
    [bool] $enablePartitioning,
    [parameter(Mandatory = $false)]
    [string[]] $tags = ""
)
Write-Host "Deploying the topic channel"

# Create the namespace
Write-Host "Deploying the namespace: $namespace"
az servicebus namespace create --resource-group $resourceGroupName --name $namespace --location $location --sku $sku --tags $tags

# Create the service bus topic
Write-Host "Deploying the topic: $topic"
az servicebus topic create --resource-group $resourceGroupName --namespace-name $namespace --name $topic --enable-partitioning $enablePartitioning

Write-Host "Deployment Complete"