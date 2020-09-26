<#
.SYNOPSIS
Creates an App Insights resource for use by various AIM components.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroupName
Name of the resource group where the resources will be created.

.PARAMETER name
Name of the App Insights resource that will be created.

.PARAMETER tags
The tags to apply to the App Insights resource.

.EXAMPLE
./New-MessageBusOps-AppInsights.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth" -name "appi-aimmsgbusops-dev" -location "uksouth"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $name,
    [parameter(Mandatory = $true)]
    [string] $location,
    [parameter(Mandatory = $false)]
    [string[]] $tags = ""
)

Write-Host "Deploying the App Insights resource"

az extension add --name application-insights
az monitor app-insights component create --app $name --location $location --kind web --resource-group $resourceGroupName --application-type web --tags $tags

Write-Host "Deployment complete"