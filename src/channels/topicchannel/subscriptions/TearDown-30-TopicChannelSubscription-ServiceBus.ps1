<#
.SYNOPSIS
Invokes the teardown of a topic subscription resource.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./TearDown-30-TopicChannelSubscription-ServiceBus.ps1
#>

& $PSScriptRoot\Remove-TopicChannelSubscription-ServiceBus.ps1 -resourceGroupName "rg-aimapp-app1-dev-uksouth-xxxxx" -resourceName "sbs-aimmsgbox-ftp-passthru" -serviceBusNamespace "sb-aimmsgbox-dev-uksouth-xxxxx" -serviceBusTopic "messagebox"
