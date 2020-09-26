<#
.SYNOPSIS
Removes an on-premise data gateway,.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroupName
The name of the resource group name the connection gateway exists in.

.PARAMETER dataGatewayName
The name of the data gateway to remove.

.EXAMPLE
.\Remove-DataGateway.ps1 -resourceGroupName "rg-aimmsgbus-dev" -dataGatewayName "cgw-aimmsgbus-dev-uksouth-xxxx"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $dataGatewayName
)

$resourceExists = az resource show --resource-group $resourceGroupName  --name $dataGatewayName --namespace "Microsoft.Web" --resource-type "connectionGateways"

if ($resourceExists) {
    Write-Host "Removing the On-premises Data Gateway $dataGatewayName"

    az resource delete --resource-group $resourceGroupName --name $dataGatewayName --namespace "Microsoft.Web" --resource-type "connectionGateways"

    Write-Host "Removed the On-premises Data Gateway $dataGatewayName"
}
else {
    Write-Host "The On-premises Data Gateway $dataGatewayName does not exist in resource group $resourceGroupName"
}