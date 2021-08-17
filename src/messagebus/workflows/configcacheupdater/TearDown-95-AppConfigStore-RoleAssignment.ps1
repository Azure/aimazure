<#
.SYNOPSIS
Invokes the removal of a Logic App from a given role in the App Config Store.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-100-AppConfigStore-RoleAssignment.ps1
#>

& $PSScriptRoot\Remove-AppConfigStore-RoleAssignment.ps1 -appConfigStoreName "appcfg-aimrstore-dev-xxxxx" -logicAppName "logic-aimconfigcacheupdater-dev-xxxxx" -roleName "Contributor"