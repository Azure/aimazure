<#
.SYNOPSIS
Deploys an API connection resource for the topic publisher.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-90-TopicPublisher-ApiConnection.ps1
#>

& $PSScriptRoot\New-TopicPublisher-ApiConnection.ps1 -resourceGroupName "rg-aimapp-systemapplication-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\topicpublisher.apiconnection.json" -templateParameterFile "$PSScriptRoot\topicpublisher.apiconnection.dev.parameters.json" -deploymentName "topicpublisher.apiconnection.uksouth.xxxxx"