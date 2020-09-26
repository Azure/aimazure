<#
.SYNOPSIS
Invokes the teardown of the topic channel resource.
.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.
.EXAMPLE
.\TearDown-20-TopicChannel-ServiceBus.ps1
#>

$params = Get-Content -Path $PSScriptRoot\topicchannel.sb.dev.psparameters.json -Raw | ConvertFrom-Json

& $PSScriptRoot\Remove-TopicChannel-ServiceBus.ps1 -resourceGroupName $params.resourceGroupName -resourceName $params.namespace