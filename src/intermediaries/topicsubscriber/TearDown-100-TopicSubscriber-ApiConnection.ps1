<#
.SYNOPSIS
Invokes the teardown of topic subscriber api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-100-TopicSubscriber-ApiConnection.ps1
#>

& $PSScriptRoot\Remove-TopicSubscriber-ApiConnection.ps1 -resourceGroup "rg-aimapp-aim-ftppassthru-dev-uksouth-xxxxx" -resourceName "apic-topicsubscriberconnector-aim-ftppassthru-sendport-dev-xxxxx"