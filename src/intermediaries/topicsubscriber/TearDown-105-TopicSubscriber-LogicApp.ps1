<#
.SYNOPSIS
Invokes the teardown of the topic subscriber logic app.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-105-TopicSubscriber-LogicApp.ps1
#>

& $PSScriptRoot\Remove-TopicSubscriber-LogicApp.ps1 -resourceGroup "rg-aimapp-systemapplication-dev-uksouth-xxxxx" -workflowName "logic-aimtopicsubscriber-aim-ftppassthru-sendport-dev-xxxxx"