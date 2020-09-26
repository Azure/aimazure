<#
.SYNOPSIS
Tears down the schema in store.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER schemaName
The name of the artifact in the store to remove.

.PARAMETER resourceGroupName
The resource group the artifact store was deployed to.

.EXAMPLE
Remove-Schema.ps1 -resourceGroup "rg-aimmsgbus-dev-uksouth" - integrationAccount "intacc-aimartifactstore-dev-uksouth" -schemaFile ".\TestApplication.TestSchema.xsd"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $schemaFile,
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $integrationAccountName
)

$schemaName = [System.IO.Path]::GetFileNameWithoutExtension($schemaFile) 

Write-Host "Removing the Schema $schemaName from Integration Account $integrationAccountName"

$urlRequest = "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/$resourceGroupName/providers/Microsoft.Logic/integrationAccounts/$integrationAccountName/schemas/" + $schemaName + "?api-version=2019-05-01" 

Write-Host "urlRequest= $urlRequest"

az rest --method DELETE --uri $urlRequest  

Write-Host "Removed the schema $schemaName from integration account: $integrationAccountName"