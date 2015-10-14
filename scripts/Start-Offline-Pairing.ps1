<#
.SYNOPSIS

PingID API Sample Powershell Script: Start-Offline-Pairing.ps1

.DESCRIPTION

This script will start the offline pairing process and return the sessionId value required for the FinalizeOfflinePairing operation. For more information, review the API documentation: https://developer.pingidentity.com/en/api/pingid-api.html

Note: This software is open sourced by Ping Identity but not supported commercially as such. Any questions/issues should go to the Github issues tracker or discuss on the Ping Identity developer communities. See also the DISCLAIMER file in this directory.

.PARAMETER UserName

The PingID user name you want to pair.

.PARAMETER Type

The offline pairing method (SMS, VOICE or EMAIL)

.PARAMETER PairingData

The email address or phone number of the user to pair.

.EXAMPLE

Start-Offline-Pairing -UserName meredith -Type SMS -PairingData 15551234567

.LINK

https://developer.pingidentity.com
#>

param(
	[Parameter (Mandatory=$true)]
	[string]$UserName,
	[Parameter (Mandatory=$true)]
	[string]$Type,
	[Parameter (Mandatory=$true)]
	[string]$PairingData
)


#	Import PingID API helper functions
. .\pingid-api-helper.ps1


#	Create the API request and parse the results.
$apiEndpoint = "https://idpxnyl3m.pingidentity.com/pingid/rest/4/startofflinepairing/do"

$reqBody = @{
	"username" = $UserName
	"type" = $Type
	"pairingData" = $PairingData
}

$responsePayload = Call-PingID-API $reqBody $apiEndpoint
$responseObj = $responsePayload | ConvertFrom-Json
Write-Output $responseObj.responseBody.sessionId
