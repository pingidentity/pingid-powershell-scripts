<#
.SYNOPSIS

PingID API Sample Powershell Script: Get-Pairing-Status.ps1

.DESCRIPTION

This script will check the status of a pending activation for a newly activated PingID user. For more information, review the API documentation: https://developer.pingidentity.com/en/api/pingid-api.html

Note: This software is open sourced by Ping Identity but not supported commercially as such. Any questions/issues should go to the Github issues tracker or discuss on the Ping Identity developer communities. See also the DISCLAIMER file in this directory.

.PARAMETER ActivationCode

The activation code returned from an Online or Offline pairing request.

.EXAMPLE

Get-Pairing-Status -ActivationCode 1234567890

.LINK

https://developer.pingidentity.com
#>

param(
	[Parameter (Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
	[string]$ActivationCode
)


#	Import PingID API helper functions
. .\pingid-api-helper.ps1


#	Create the API request and parse the results.
$apiEndpoint = "https://idpxnyl3m.pingidentity.com/pingid/rest/4/pairingstatus/do"

$reqBody = @{
	"activationCode" = $ActivationCode
}

$responsePayload = Call-PingID-API $reqBody $apiEndpoint -Verbose
$responseObj = $responsePayload | ConvertFrom-Json
Write-Output $responseObj.responseBody.pairingStatus
