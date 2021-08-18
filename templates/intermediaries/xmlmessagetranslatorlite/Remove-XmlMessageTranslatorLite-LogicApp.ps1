<#
.SYNOPSIS
Tears down the Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroup
The name of the resource group containing the resources to remove.

.PARAMETER workflowName
The name of the Logic App to find the resource.

.EXAMPLE
.\Remove-XmlMessageTranslatorLite-LogicApp.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth-xxxxx" -workflowName "logic-xmlmessagetranslatorlite-dev-xxxxx"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $workflowName
)

$resourceExists = az resource show --resource-group $resourceGroupName  --name $workflowName --namespace "Microsoft.Logic" --resource-type "workflows"

if ($resourceExists) {
    Write-Host "Removing the Logic App $workflowName"

    az resource delete --resource-group $resourceGroupName --name $workflowName --namespace "Microsoft.Logic" --resource-type "workflows"

    Write-Host "Removed the Logic App $workflowName"
}
else {
    Write-Host "The Logic App $workflowName does not exist in resource group $resourceGroupName"
}