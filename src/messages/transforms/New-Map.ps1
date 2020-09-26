<#
.SYNOPSIS
Add a Map to the artifact store.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER templateFile
Path to the ARM template that needs to be deployed.

.PARAMETER templateParameterFile
Path to the ARM template parameter file that contains the parameter values related to the template file.

.PARAMETER resourceGroup
The resource group to deploy to.

.EXAMPLE
New-Schema.ps1 -$requestBodyFile ".\body.dev.json" -mapFile ".\TestApplication.TestSchema.xsd" -resourceGroupName "rg-aimmsgbus-dev-uksouth" - integrationAccountName "intacc-aimartifactstore-dev-uksouth"
#>

[CmdletBinding()]
Param(
  [parameter(Mandatory = $true)]
  [string] $requestBodyFile,
  [parameter(Mandatory = $true)]
  [string] $mapFile,
  [parameter(Mandatory = $true)]
  [string] $resourceGroupName,
  [parameter(Mandatory = $true)]
  [string] $integrationAccountName
)

# \\?\ is only supported for PS5
If ($PSVersionTable.PSVersion.Major -ge 7) {
  $requestBodyFile = $requestBodyFile.Replace("\\?\", "") 
}

$mapName = [System.IO.Path]::GetFileNameWithoutExtension($mapFile) 

Write-Host "Deploying the Map to the store`r`n Body File: $requestBodyFile`r`n Schema File: $schemaFile`r`n Resource Group: $resourceGroupName`r`n Integration Account: $integrationAccountName`r`n Map Name $mapName`r`n"

$content = [System.IO.File]::ReadAllText($mapFile)
$requestBodyParams = Get-Content -Path $requestBodyFile -Raw | ConvertFrom-Json 
$requestBodyParams.properties.content = $content
$requestBodyParams | ConvertTo-Json -Depth 10 | Set-Content $requestBodyFile

$urlRequest = "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/$resourceGroupName/providers/Microsoft.Logic/integrationAccounts/$integrationAccountName/maps/" + $mapName + "?api-version=2019-05-01" 
Write-Host "urlRequest= $urlRequest"

az rest --method PUT --headers Content-Type='application/json; charset=utf-8'  --uri $urlRequest --body @$requestBodyFile

Write-Host "Deployment complete"