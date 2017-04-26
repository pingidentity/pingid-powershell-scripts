<#
.SYNOPSIS

PingID API Sample Powershell Script: Create-Job.ps1

.DESCRIPTION

This script will create a new reporting job in PingID using the PingID API.  For more information, review the API documentation: https://developer.pingidentity.com/en/api/pingid-api.html

Note: This software is open sourced by Ping Identity but not supported commercially as such. Any questions/issues should go to the Github issues tracker or discuss on the Ping Identity developer communities. See also the DISCLAIMER file in this directory.

.PARAMETER JobType

The PingID Job Type. Currently, the only supported type is: USER_REPORTS (must be upper case with an underscore (_).

.EXAMPLE

Create-Job -JobType USER_REPORTS

.LINK

https://developer.pingidentity.com
#>

param(
	[Parameter (Mandatory=$true)]
	[string]$JobType
)

#  Import PingID API helper functions
. .\pingid-api-helper.ps1


#	Create the API request and parse the results.
$createJobEndpoint = "https://idpxnyl3m.pingidentity.com/pingid/rest/4/createjob/do"
$createJobBody = @{
	"jobType" = $JobType
}

$responsePayload = Call-PingID-API $createJobBody $createJobEndpoint
Write-Output $responsePayload 
