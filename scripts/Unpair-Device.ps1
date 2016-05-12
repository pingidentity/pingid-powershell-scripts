<#
.SYNOPSIS

PingID API Sample Powershell Script: Unpair-Device.ps1

.DESCRIPTION

This script will unpair a device from a specific PingID user. For more information, review the API documentation: https://developer.pingidentity.com/en/api/pingid-api.html

Note: This software is open sourced by Ping Identity but not supported commercially as such. Any questions/issues should go to the Github issues tracker or discuss on the Ping Identity developer communities. See also the DISCLAIMER file in this directory.

.PARAMETER UserName

The PingID user name you want to unpair from their device.

.EXAMPLE

Unpair-Device -UserName meredith

.LINK

https://developer.pingidentity.com
#>

param(
	[Parameter (Mandatory=$true)]
	[string]$UserName
)


#	Import PingID API helper functions
. .\pingid-api-helper.ps1


#	Create the API request and parse the results.
$apiEndpoint = "https://idpxnyl3m.pingidentity.com/pingid/rest/4/unpairdevice/do"

$reqBody = @{
	"userName" = $UserName
}

$responsePayload = Call-PingID-API $reqBody $apiEndpoint
Write-Output $responsePayload

# Retrieve the User Details to verify call
$reqBody = @{
	"userName" = $UserName
	"getSameDeviceUsers" = $false
}
$responsePayload = Call-PingID-API $reqBody "https://idpxnyl3m.pingidentity.com/pingid/rest/4/getuserdetails/do"
Write-Output $responsePayload