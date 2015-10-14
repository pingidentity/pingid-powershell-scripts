<#
.SYNOPSIS

PingID API Sample Powershell Script: Toggle-User-Bypass.ps1

.DESCRIPTION

This script will toggle the bypass flag on a PingID user. Set the bypass to zero to remove the bypass. For more information, review the API documentation: https://developer.pingidentity.com/en/api/pingid-api.html

Note: This software is open sourced by Ping Identity but not supported commercially as such. Any questions/issues should go to the Github issues tracker or discuss on the Ping Identity developer communities. See also the DISCLAIMER file in this directory.

.PARAMETER UserName

The PingID user name you want to activate.

.PARAMETER Days

(optional) The number of days you want to bypass.

.PARAMETER Hours

(optional) The number of hours you want to bypass.

.PARAMETER Minutes

(optional) The number of minutes you want to bypass.

.EXAMPLE

Toggle-User-ByPass -UserName meredith -Hours 1 -Minutes 30

.LINK

https://developer.pingidentity.com
#>

param(
	[Parameter (Mandatory=$true)]
	[string]$UserName,
	[int]$Days = 0,
	[int]$Hours = 0,
	[int]$Minutes = 0
)


#	Import PingID API helper functions
. .\pingid-api-helper.ps1


#	Create the API request and parse the results.
$apiEndpoint = "https://idpxnyl3m.pingidentity.com/pingid/rest/4/userbypass/do"
$secondsToBypass = ($Minutes * 60) + ($Hours * 3600) + ($Days * 86400)

if ($secondsToBypass -eq 0) {
	$bypassUntil = $null
} else {
	$currentEpoch = [int][double]::Parse($(Get-Date -date (Get-Date).ToUniversalTime()-uformat %s))
	$bypassUntil = ($currentEpoch + $secondsToBypass) * 1000
}

$reqBody = @{
	"userName" = $UserName
	"spAlias" = $null
	"bypassUntil" = $bypassUntil
}

$reqBodyJson = $reqBody | ConvertTo-Json
Write-Host "Request body: " $reqBodyJson
$responsePayload = Call-PingID-API $reqBody $apiEndpoint


#	Retrieve the User Details to verify call
$userDetailsEndpoint = "https://idpxnyl3m.pingidentity.com/pingid/rest/4/getuserdetails/do"
$userDetailsBody = @{
	"userName" = $UserName
	"getSameDeviceUsers" = $false
}
$responsePayload = Call-PingID-API $userDetailsBody $userDetailsEndpoint
Write-Output $responsePayload
