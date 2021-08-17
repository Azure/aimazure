<#
.SYNOPSIS
Invokes the assignment of a Logic App to a given role in the App Config Store.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-100-AppConfigStore-RoleAssignment.ps1
#>

& $PSScriptRoot\New-AppConfigStore-RoleAssignment.ps1 -appConfigStoreName "appcfg-aimrstore-dev-xxxxx" -logicAppName "logic-aimconfigcacheupdater-dev-xxxxx" -roleName "Contributor"