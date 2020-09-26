<#
.SYNOPSIS
Tears down the resource group for an application.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroup
The resource group name to remove.

.EXAMPLE
Remove-ApplicationGroup.ps1 resourceGroup "rg-aimapp-thunderstorm-test-dev"
    #>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroup
)
$resourceGroupExists = az group exists --name $resourceGroup

if ($resourceGroupExists -eq $true) {
    Write-Host "Removing the resource group: $resourceGroup"

    az group delete --name $resourceGroup --yes

    Write-Host "Removed the resource group: $resourceGroup"
}
else {
    Write-Host "The resource group: $resourceGroup does not exist"
}

