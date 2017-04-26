<#
.SYNOPSIS

PingID API Sample Powershell Script: Get-PingID-Report.ps1

.DESCRIPTION

This script creates a PingID reporting job, queries the status and downloads the report in the reqested format. For more information, review the API documentation: https://developer.pingidentity.com/en/api/pingid-api.html

.PARAMETER FileType

The PingID file format for the report.

.EXAMPLE

Get-PingID-Report -FileType CSV

.LINK

https://developer.pingidentity.com
#>

param(
    [Parameter (Mandatory=$true)]
	[string] $FileType
)


#	Import PingID API helper functions
. .\pingid-api-helper.ps1


#Call the script to Create the Reporting Job and capture the jobToken
$JobPayload = .\Create-Job.ps1 | ConvertFrom-Json

[string] $jobToken = $jobPayload.responseBody.jobToken
write-Output $jobToken

#Loop through hitting the Get-Job-Status script/API every 10 seconds until the job is either done or fails
$status = $false
while ($status -eq $false) {
start-sleep 10
$jobStatusPayload = .\Get-Job-Status $jobToken | ConvertFrom-Json
$jobStatus = $jobStatusPayload.responseBody.status
   if ($jobStatus -eq "pending") {
      Write-Output "Job Pending..."
   } elseif ($jobStatus -eq "in_progress") {
      Write-OutPut "Job In Progress..."
   } elseif ($jobStatus -eq "done") {
      Write-OutPut "Job Completed!"
      $status=$true
   } elseif ($jobStatus -eq "failure") {
      Write-OutPut "Job Failed!"
      break
   } else {
      Write-OutPut "Abort!  Unexpected Job Status."
      break
   }
}

#Call the script to download the report, if the job completed successfully.
if ($status=$true) {
   $responsePayload = .\Get-Organization-Report.ps1 $FileType
   Write-Output $responsePayload
}
