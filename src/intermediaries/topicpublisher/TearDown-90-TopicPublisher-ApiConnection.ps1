<#
.SYNOPSIS
Tears down the api connection for the topic publisher.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-90-TopicPublisher-ApiConnection.ps1
#>

& $PSScriptRoot\Remove-TopicPublisher-ApiConnection.ps1 -resourceGroup "rg-aimapp-systemapplication-dev-uksouth-xxxxx" -workflowName "apic-topicpublisherconnector-dev-xxxxx"