<#
.SYNOPSIS
Invokes the deployment of a message bus group.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
Deploy-10-MessageBusGroup.ps1
#>

& $PSScriptRoot\New-MessageBusGroup.ps1 -templateFile "$PSScriptRoot\messagebusgroup.json" -templateParameterFile "$PSScriptRoot\messagebusgroup.dev.parameters.json" -deploymentName "messagebusgroup.uksouth.xxxxx" -deploymentDataLocation "UK South"
