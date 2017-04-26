<#
.SYNOPSIS

PingID API Sample Powershell Script: Get-Job-Status.ps1

.DESCRIPTION

This script will query the PingID API GetJobStatus operation to return the details about a given reporting job. For more information, review the API documentation: https://developer.pingidentity.com/en/api/pingid-api.html

Note: This software is open sourced by Ping Identity but not supported commercially as such. Any questions/issues should go to the Github issues tracker or discuss on the Ping Identity developer communities. See also the DISCLAIMER file in this directory.

.PARAMETER JobToken

The PingID reporting job you want to retrieve the status of. The JobToken is provided in the response of Create-Job.ps1

.EXAMPLE

Get-Job-Status -JobToken VgpSBgNVAwAAAwAAUAAAAgoHAFkEBgUAAwhbVAJTAFYBUF4F

.LINK

https://developer.pingidentity.com
#>

param(
	[Parameter (Mandatory=$true)]
	[string]$JobToken
)


#	Import PingID API helper functions
. .\pingid-api-helper.ps1


#	Create the API request and parse the results.
$getJobStatusEndpoint = "https://idpxnyl3m.pingidentity.com/pingid/rest/4/getjobstatus/do"
$getJobStatusBody = @{
	"jobToken" = $JobToken
}

$responsePayload = Call-PingID-API $getJobStatusBody $getJobStatusEndpoint
Write-Output $responsePayload
