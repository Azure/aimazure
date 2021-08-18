<#
.SYNOPSIS
Invokes the deployment of the Application Logic App Workflows.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-115-Application-LogicApp-Workflows.ps1
#>

& $PSScriptRoot\New-Application-LogicApp-Workflows.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-xxxxx" -resourceName "logic-application-dev-xxxxx" -workflowFolder "$PSScriptRoot\application.logic.workflows"
