<#
.SYNOPSIS
Invokes the deployment of a Function resource which implements the messaging manager operations.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./Deploy-50-MessagingManager-Function.ps1
#>

& $PSScriptRoot\New-MessagingManager-Function.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth" -resourceName "func-aimmsgmgr-dev-001" -templateFile "$PSScriptRoot\messagingmanager.func.json" -templateParameterFile "$PSScriptRoot\messagingmanager.func.dev.parameters.json" -deploymentName "messagingmanager.func.uksouth.xxxxx" -zipFile "..\..\..\dist\functions\Microsoft.Azure.Aim.FunctionApp.MessagingManager.zip"
