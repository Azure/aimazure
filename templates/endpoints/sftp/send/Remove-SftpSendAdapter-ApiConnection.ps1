<#
.SYNOPSIS
Tears down the sftp connector.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroup
The name of the resource group containing the resources to remove.

.PARAMETER resourceName
The name of the resource to remove.

.EXAMPLE
./Remove-SftpSendAdapter-ApiConnection.ps1 -resourceGroupName "rg-aimapp-aim-sftppassthru-dev-uksouth-xxxxx" -resourceName "sftpreceiveconnector-Aim-SftpPassthru-ReceiveLocation-dev-xxxxx"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $resourceName
)

$resourceExists = az resource show --name $resourceName --resource-group $resourceGroupName --resource-type "connections" --namespace "Microsoft.Web"

if ($resourceExists) {
    Write-Host "Removing the sftp connector resource: $resourceName"

    az resource delete --name $resourceName --resource-group $resourceGroupName --resource-type "connections" --namespace "Microsoft.Web"

    Write-Host "Removed the sftp connector resource: $resourceName"
}
else {
    Write-Host "The sftp connector resource $resourceName does not exist in resource group $resourceGroupName"
}
