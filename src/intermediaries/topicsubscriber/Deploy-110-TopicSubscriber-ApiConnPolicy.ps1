<#
.SYNOPSIS
Invokes the deployment of the topic subscriber api connection access policy.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-110-TopicSubscriber-ApiConnPolicy.ps1
#>

& $PSScriptRoot\New-TopicSubscriber-ApiConnPolicy.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\topicsubscriber.apiconnpolicy.json" -templateParameterFile "$PSScriptRoot\topicsubscriber.apiconnpolicy.dev.parameters.json" -deploymentName "topicsubscriber.apicaccesspolicy.uksouth.xxxxx"