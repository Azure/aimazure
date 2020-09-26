<#
.SYNOPSIS
Invokes the deployment of a Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-95-TopicPublisher-LogicApp.ps1
#>

& $PSScriptRoot\New-TopicPublisher-LogicApp.ps1 -resourceGroupName "rg-aimapp-systemapplication-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\topicpublisher.logicapp.json" -templateParameterFile "$PSScriptRoot\topicpublisher.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -deploymentName "topicpublisher.logicapp.uksouth.xxxxx"
