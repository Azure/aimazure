<#
.SYNOPSIS
Invokes the deployment of the Application Logic App Configuration.
This script will merge the individual workflow config files into single files,
prior to the workflows app being uploaded to the Logic App in Azure.
Note that if you want to open this Logic App project in VS Code,
you need to run this script first.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-110-Application-LogicApp-Configuration.ps1
#>

& $PSScriptRoot\New-Application-LogicApp-Configuration.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-xxxxx" -resourceName "logic-application-dev-xxxxx" -workflowFolder "$PSScriptRoot\application.logic.workflows"
