<#
.SYNOPSIS
Creates a topic subscription and rules resources.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroupName
Name of the resource group where the resources will be created.

.PARAMETER name
Name of the subscription that will be created.

.PARAMETER serviceBusNamespace
Name of the Azure Service Bus namespace.

.PARAMETER serviceBusTopic
Name of the Azure Service Bus topic.

.PARAMETER serviceBusSessionsEnabled
Identifies if sessions are enabled (true) or not (false).

.PARAMETER rules
The rules to set on the subscription.

.EXAMPLE
./New-TopicChannelSubscription-ServiceBus.ps1 -resourceGroupName "rg-aimapp-app1-dev-uksouth" -name "sbs-aimmsgbox-ftp-passthru" -serviceBusNamespace "sb-aimmsgbox-dev-uksouth" -serviceBusTopic "messagebox" -serviceBusSessionsEnabled "true" -rules @{<rulesarray>}
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $name,
    [parameter(Mandatory = $true)]
    [string] $serviceBusNamespace,
    [parameter(Mandatory = $true)]
    [string] $serviceBusTopic,
    [parameter(Mandatory = $true)]
    [bool] $serviceBusSessionsEnabled,
    [parameter(Mandatory = $true)]
    [object[]] $rules
)

# --------------------------------------------------------------------------

Write-Host "Deploying the topic subscription $name"

az servicebus topic subscription create --name $name --resource-group $resourceGroupName --namespace-name $serviceBusNamespace --topic-name $serviceBusTopic --enable-session $serviceBusSessionsEnabled
if (!$?) {
    throw "Deployment failed, aborting"
}

Write-Host "Deployment complete"

# --------------------------------------------------------------------------

Write-Host "Creating rules for subscription $name"

ForEach ($rule in $rules) {
    $ruleName = $rule.name

    Write-Host "Creating rule $ruleName in subscription $name"

    az servicebus topic subscription rule create --name $ruleName --resource-group $resourceGroupName --namespace-name $serviceBusNamespace --topic-name $serviceBusTopic --subscription-name $name --filter-sql-expression $rule.expression
    if (!$?) {
        throw "Deployment failed, aborting"
    }
}

Write-Host "Created rules for subscription $name"
