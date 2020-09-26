<#
.SYNOPSIS
Invokes the deployment of a Service BUs topic channel resource for use by various AIM components
.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.
.EXAMPLE
.\Deploy-20-TopicChannel-ServiceBus.ps1
#>

$params = Get-Content -Path $PSScriptRoot\topicchannel.sb.dev.psparameters.json -Raw | ConvertFrom-Json
& $PSScriptRoot\New-TopicChannel-ServiceBus.ps1 -resourceGroupName $params.resourceGroupName -location $params.location -namespace $params.namespace -sku $params.sku -topic $params.topic.name -enablePartitioning $params.topic.enablePartitioning -tags $params.tags