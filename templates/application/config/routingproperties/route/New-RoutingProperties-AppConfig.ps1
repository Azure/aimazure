<#
.SYNOPSIS
Creates routing properties in app config.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER configStoreName
The name of the application configuration store.

.PARAMETER key
The key for the configuration item.

.PARAMETER value
The value for the configuration item

.PARAMETER type
The type assigned to the configuration item.

.PARAMETER label
The label for the configuration item.

.PARAMETER tags
The tags to apply to the configuration item.

.EXAMPLE
.\New-RoutingProperties-AppConfig.ps1 -configStoreName "appcfg-aimroutestore-dev" -key "SampleConfigKey" -value "{ ""samplekey"": ""samplevalue"" }" -type configType -label "sample label"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]    
    [string] $configStoreName,
    [parameter(Mandatory = $true)]
    [string] $key,
    [parameter(Mandatory = $true)]
    [string] $value,
    [parameter(Mandatory = $true)]
    [string] $type,
    [parameter(Mandatory = $true)]
    [string] $label,
    [parameter(Mandatory = $false)]
    [string[]] $tags = ""
)

Write-Host "Deploying routing properties with the key $key"

az appconfig kv set --name $configStoreName --key $key --value $value --content-type $type --label $label --tags $tags --yes 

Write-Host "Deployment complete routing properties with the key $key"