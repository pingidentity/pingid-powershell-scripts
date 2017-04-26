<#
.SYNOPSIS

PingID API Sample Powershell Script: Get-Organization-Report.ps1

.DESCRIPTION

This script will download a report from the PingID API in the specified format using the GetOrgReport operation. For more information, review the API documentation: https://developer.pingidentity.com/en/api/pingid-api.html

Note: This software is open sourced by Ping Identity but not supported commercially as such. Any questions/issues should go to the Github issues tracker or discuss on the Ping Identity developer communities. See also the DISCLAIMER file in this directory.

.PARAMETER FileType

The format that you want your PingID Report in: CSV or JSON.

.EXAMPLE

Get-Organization-Report -FileType JSON

.LINK

https://developer.pingidentity.com
#>

param(
	[Parameter (Mandatory=$true)]
	[string]$FileType
)

#	Import PingID API helper functions
. .\pingid-api-helper.ps1


#	Create the API request and parse the results.
$orgReportEndpoint = "https://idpxnyl3m.pingidentity.com/pingid/rest/4/getorgreport/do"
$orgReportBody = @{
	"fileType" = $FileType
}

$responsePayload = Call-PingID-API $orgReportBody $orgReportEndpoint $fileType
Write-Output $responsePayload
