<#
.SYNOPSIS
Deploys an ftp server.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER adminUserPassword
The admin password for the ftp server.

.PARAMETER ftpUserPassword
The ftp user password.

.PARAMETER publicDnsNamePrefix
The prefix to apply to the public dns name for the ftp server.

.EXAMPLE
.\Deploy-10-FtpServer -adminUserPassword "Password1234#" -ftpUserPassword "Password1234#" -publicDnsNamePrefix "abc"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    $adminUserPassword,
    [parameter(Mandatory = $true)]
    $ftpUserPassword,
    [parameter(Mandatory = $false)]
    [string] $publicDnsNamePrefix = $Env:AIM_USER_PREFIX
)
$params = Get-Content -Path $PSScriptRoot\ftpserver.vm.dev.psparameters.json -Raw | ConvertFrom-Json
$publicDnsName = $publicDnsNamePrefix + "-" + $params.virtualMachine.publicDnsName

& $PSScriptRoot\New-FtpServer.ps1 -ftpServerName $params.virtualMachine.name -resourceGroupName $params.virtualMachine.resourceGroupName -location $params.virtualMachine.location -publicDnsName $publicDnsName -adminUserName $params.virtualMachine.adminUserName -adminUserPassword $adminUserPassword -ftpUserName $params.virtualMachine.ftpUserName -ftpUserPassword $ftpUserPassword -tags $params.virtualMachine.tags -osImageUrn $params.osImage.urn