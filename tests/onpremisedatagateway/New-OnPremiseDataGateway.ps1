<#
.SYNOPSIS
Deploys the on premise data gateway and configures a local cluster.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER uniqueDeploymentId
The unique deployment id used in the automated deployment.

.PARAMETER gatewayClusterNamePrefix
The prefix to be used for the name of the gateway cluster.

.PARAMETER location
The location the cluster will be deployed in.

.EXAMPLE
.\New-OnPremiseDataGateway.ps1 -uniqueDeploymentId "xxxxxx" -gatewayClusterNamePrefix "dgwc-aimfile-dev" -location "uksouth"
#>

#requires -version 7

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]    
    [string] $uniqueDeploymentId,
    [parameter(Mandatory = $true)]    
    [string] $gatewayClusterNamePrefix,
    [parameter(Mandatory = $true)]    
    [string] $location
)

$dataGatewayModuleName = "DataGateway"

# Install the PowerShell module to manage the on premise data gateway, if required.
If (Get-InstalledModule -Name $dataGatewayModuleName -ErrorAction SilentlyContinue) { 
    Write-Output "The $dataGatewayModuleName module is already installed"
}
Else { 
    Write-Output "Checking for the nuget package provider and installing if missing"
    
    Get-PackageProvider -Name NuGet -ForceBootstrap 
    
    Write-Output "Installing the PowerShell module $dataGatewayModuleName"

    Install-Module -Name $dataGatewayModuleName -Force -Confirm:$false -Scope CurrentUser

    Write-Output "Installed the PowerShell module $dataGatewayModuleName"
}

Import-Module DataGateway

# Check to see if user is logged into the DataGateway.
try { 
    Get-DataGatewayAccessToken | Out-Null 
}
catch {    
    # Not logged in, force a login.
    Write-Output "Please login to the data gateway provider using your browser, the script will continue automatically after you login"

    Login-DataGateway

    Write-Output "User logged in"
}

Write-Output "Installing the data gateway"

Install-DataGateway -AcceptConditions

Write-Output "Installed the data gateway"

# Create the recovery key.
$guid = [Guid]::NewGuid().ToString('N')
$recoveryKey = $guid | ConvertTo-SecureString -AsPlainText -Force

# Format the gateway name.
$fullGatewayName = "$gatewayClusterNamePrefix-$location-$uniqueDeploymentId"

# Add the data gateway cluster.
Write-Output "Adding the data gateway cluster name: $fullGatewayName recovery key : $guid"

Add-DataGatewayCluster -RecoveryKey $recoveryKey -GatewayName $fullGatewayName -RegionKey uksouth -OverwriteExistingGateway

Write-Output "Added the data gateway cluster"