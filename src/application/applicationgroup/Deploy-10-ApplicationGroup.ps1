<#
.SYNOPSIS
Invokes the deployment of an application group.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
Deploy-10-ApplicationGroup.ps1
#>

& $PSScriptRoot\New-ApplicationGroup.ps1 -templateFile "$PSScriptRoot\applicationgroup.json" -templateParameterFile "$PSScriptRoot\applicationgroup.dev.parameters.json" -deploymentName "applicationgroup.uksouth.xxxxx" -deploymentDataLocation "UK South"
