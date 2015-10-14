<#
.SYNOPSIS

PingID API Sample Powershell Script: Finalize-Offline-Pairing.ps1

.DESCRIPTION

This script will complete the offline pairing process using the OTP received by the user and the sessionId received from the StartOfflinePairing operation. For more information, review the API	documentation: https://developer.pingidentity.com/en/api/pingid-api.html

Note: This software is open sourced by Ping Identity but not supported commercially as such. Any questions/issues should go to the Github issues tracker or discuss on the Ping Identity developer communities. See also the DISCLAIMER file in this directory.

.PARAMETER SessionId

The SessionId returned from the StartOfflinePairing operation.

.PARAMETER OTP

The one-time password (OTP) the user received out-of-band (ie via SMS or Email)

.EXAMPLE

Finalize-Offline-Pairing -SessionId 1234567890 -OTP 123456

.LINK

https://developer.pingidentity.com
#>

param(
	[Parameter (Mandatory=$true)]
	[string]$SessionId,
	[Parameter (Mandatory=$true)]
	[string]$OTP
)


#	Import PingID API helper functions
. .\pingid-api-helper.ps1


#	Create the API request and parse the results.
$apiEndpoint = "https://idpxnyl3m.pingidentity.com/pingid/rest/4/finalizeofflinepairing/do"

$reqBody = @{
	"sessionId" = $SessionId
	"otp" = $OTP
}

$responsePayload = Call-PingID-API $reqBody $apiEndpoint
$responseObj = $responsePayload | ConvertFrom-Json
if ($responseObj.responseBody.errorId -eq 200) {
	Write-Output "PAIRED DEVICE"
} else {
	Write-Output "FAILED TO PAIR"
}
