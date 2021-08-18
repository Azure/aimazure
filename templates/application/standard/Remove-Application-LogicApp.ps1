<#
.SYNOPSIS
Tears down the Application Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroup
The name of the resource group containing the resources to remove.

.PARAMETER logicAppName
The name of the Logic App to find the resource.

.EXAMPLE
.\Remove-Application-LogicApp.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-xxxxx" -logicAppName "logic-application-dev-xxxxx"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $logicAppName
)

$resourceExists = az resource show --resource-group $resourceGroupName  --name $logicAppName --resource-type "Microsoft.Web/sites"

if ($resourceExists) {
    Write-Host "Removing the Logic App $logicAppName"

    az resource delete --resource-group $resourceGroupName --name $logicAppName --resource-type "Microsoft.Web/sites"

    Write-Host "Removed the Logic App $logicAppName"
}
else {
    Write-Host "The Logic App $logicAppName does not exist in resource group $resourceGroupName"
}