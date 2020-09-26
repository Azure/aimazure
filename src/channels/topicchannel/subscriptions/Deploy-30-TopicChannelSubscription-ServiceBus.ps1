<#
.SYNOPSIS
Invokes the deployment of a topic subscription and rules resources.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./Deploy-30-TopicChannelSubscription-ServiceBus.ps1
#>

$params = Get-Content -Path $PSScriptRoot\topicchannelsubscription.sbs.dev.psparameters.json -Raw | ConvertFrom-Json
& $PSScriptRoot\New-TopicChannelSubscription-ServiceBus.ps1 -resourceGroupName $params.resourceGroupName -name $params.name -serviceBusNamespace $params.serviceBusNamespace -serviceBusTopic $params.serviceBusTopic -serviceBusSessionsEnabled $params.enableSession -rules $params.rules
