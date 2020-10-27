<#
.SYNOPSIS
Creates a Service Bus Namespace resource for use by various AIM components.

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

.PARAMETER tags
The tags to apply to the namespace.

.EXAMPLE
.\New-Namespace-ServiceBus.ps1 -resourceGroupName "rg-aimapp-systemapplication-dev-uksouth" -location "uksouth" -namespace "sb-aimmsgbox-dev-uksouth" -sku "Standard" 
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
    [parameter(Mandatory = $false)]
    [string[]] $tags = ""
)

Write-Host "Deploying the namespace: $namespace"

az servicebus namespace create --resource-group $resourceGroupName --name $namespace --location $location --sku $sku --tags $tags

Write-Host "Deployment Complete"