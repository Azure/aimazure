<#
.SYNOPSIS
Invokes the teardown of the topic publisher logic app.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-95-TopicPublisher-LogicApp.ps1
#>

& $PSScriptRoot\Remove-TopicPublisher-LogicApp.ps1 -resourceGroup "rg-aimapp-systemapplication-dev-uksouth-xxxxx" -resourceName "logic-aimtopicpublisher-dev-xxxxx"