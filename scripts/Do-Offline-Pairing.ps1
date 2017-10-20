<#
.SYNOPSIS

PingID API Sample Powershell Script: Do-Offline-Pairing.ps1

.DESCRIPTION

This script will do offline pairing process. 
It requires the alternate authentication methods to have the SMS method to be checked for ENABLE AND PRE-POPULATE

.PARAMETER UserName

The PingID user name you want to pair.

.PARAMETER Type

The offline pairing method (SMS, VOICE or EMAIL)

.PARAMETER PairingData

The email address or phone number of the user to pair.

.EXAMPLE

Do-Offline-Pairing -UserName testuser -Type SMS -PairingData 4112345678

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
$apiEndpoint = "https://idpxnyl3m.pingidentity.com/pingid/rest/4/offlinepairing/do"

$reqBody = @{
	"username" = $UserName
	"type" = $Type
	"pairingData" = $PairingData
}

$responsePayload = Call-PingID-API $reqBody $apiEndpoint
$responseObj = $responsePayload | ConvertFrom-Json
Write-Output "MessageID:"$responseObj.responseBody.uniqueMsgId"Status:"$responseObj.responseBody.errorMsg


