<#
.SYNOPSIS
Invokes the deployment of a topic subscriber api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-100-TopicSubscriber-ApiConnection.ps1
#>

& $PSScriptRoot\New-TopicSubscriber-ApiConnection.ps1 -resourceGroupName "rg-aimapp-aim-ftppassthru-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\topicsubscriber.apiconnection.json" -templateParameterFile "$PSScriptRoot\topicsubscriber.apiconnection.dev.parameters.json" -deploymentName "topicsubscriber.apic.uksouth.xxxxx"
