<#
.SYNOPSIS

PingID API Sample Powershell Script: Edit-User.ps1

.DESCRIPTION

This script will edit a PingID user's details in the PingID service. For more information, review the API documentation: https://developer.pingidentity.com/en/api/pingid-api.html

Note: This software is open sourced by Ping Identity but not supported commercially as such. Any questions/issues should go to the Github issues tracker or discuss on the Ping Identity developer communities. See also the DISCLAIMER file in this directory.

.PARAMETER UserName

The PingID user name you want to edit.

.PARAMETER FirstName

The first or given name of the user you are editing.

.PARAMETER LastName

The last name or surname of the user you are editing.

.PARAMETER Email

The email address of the user you are editing.

.PARAMETER Activate

(optional) Boolean. Whether to activate the user or not.

.PARAMETER Role

(optional) The PingID role (REGULAR or ADMIN) for the user.

.EXAMPLE

Edit-User -UserName meredith -FirstName Meredith -LastName Archer -Email meredith@pingdevelopers.com

.LINK

https://developer.pingidentity.com
#>

param(
	[Parameter (Mandatory=$true)]
	[string]$UserName,
	[Parameter (Mandatory=$true)]
	[string]$FirstName,
	[Parameter (Mandatory=$true)]
	[string]$LastName,
	[Parameter (Mandatory=$true)]
	[string]$Email,
	[boolean]$Activate = $false,
	[string]$Role = "REGULAR"
)


#	Import PingID API helper functions
. .\pingid-api-helper.ps1


#	Create the API request and parse the results.
$apiEndpoint = "https://idpxnyl3m.pingidentity.com/pingid/rest/4/edituser/do"

$reqBody = @{
	"userName" = $UserName
	"fName" = $FirstName
	"lName" = $LastName
	"email" = $Email
	"role" = $Role
	"activateUser" = $Activate
}

$responsePayload = Call-PingID-API $reqBody $apiEndpoint


#	Retrieve the User Details to verify call
$userDetailsEndpoint = "https://idpxnyl3m.pingidentity.com/pingid/rest/4/getuserdetails/do"
$userDetailsBody = @{
	"userName" = $UserName
	"getSameDeviceUsers" = $false
}
$responsePayload = Call-PingID-API $userDetailsBody $userDetailsEndpoint
Write-Output $responsePayload
