<#
.SYNOPSIS
Tears down the file receive adapter.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroup
The name of the resource group containing the resources to remove.

.PARAMETER resourceName
The name of the resource to remove.

.EXAMPLE
.\Remove-FileReceiveAdapter-LogicApp.ps1 -resourceGroupName "rg-aimapp-aim-filepassthru-dev-uksouth-xxxxx" -resourceName "logic-Aim-FilePassthru-ReceiveLocation-dev-xxxxx"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $resourceName
)

$resourceExists = az resource show --name $resourceName --resource-group $resourceGroupName --resource-type "workflows" --namespace "Microsoft.Logic"

if ($resourceExists) {
    Write-Host "Removing the file receive adapter resource: $resourceName"

    az resource delete --name $resourceName --resource-group $resourceGroupName --resource-type "workflows" --namespace "Microsoft.Logic"

    Write-Host "Removed the file receive adapter resource: $resourceName"
}
else {
    Write-Host "The file receive adapter resource $resourceName does not exist in resource group $resourceGroupName"
}
