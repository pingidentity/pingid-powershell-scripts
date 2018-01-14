<#
	PingID API Helper Powershell Script: pingid-api-helper.ps1
	
	This script contains common functions to call the PingID API. For more information, review
	the API documentation: https://developer.pingidentity.com/en/api/pingid-api.html
	
	Note: This software is open sourced by Ping Identity but not supported commercially as 
		  such. Any questions/issues should go to the Github issues tracker or discuss on 
		  the [Ping Identity developer communities] . See also the DISCLAIMER file in this 
		  directory.
#>

#	Replace with the PingID settings found in the PingID settings file:
#   Note: Remove any backslash characters from the use_base64_key value.

$org_alias      = "<< orgAlias value from pingid.properties file >>";
$use_base64_key = "<< use_base64_key value from pingid.properties file >>";
$token          = "<< token value from pingid.properties file >>";
$api_version    = "4.9"

function Convert-StringToByteArray {

	[CmdletBinding()]
	param (
		[Parameter (Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
		[string] $inputString
	)

	$utf8 = [System.Text.Encoding]::UTF8
	$outputBytes = $utf8.GetBytes($inputString)

	Write-Output $outputBytes
}

function Convert-ByteArrayToString {

	[CmdletBinding()]
	param (
		[Parameter (Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
		[byte[]] $inputBytes
	)

	BEGIN
	{
		$workingBytes = {@()}.Invoke()
	}
	
	PROCESS
	{ 
		if($_ -is [System.Array]) { $workingBytes = $_ } else { $workingBytes.Add($_) }
	}

	END
	{
		$utf8 = [System.Text.Encoding]::UTF8
		$outputString = $utf8.GetString($workingBytes)
		
		Write-Output $outputString
	}
}

function Encode-Base64Url {

	[CmdletBinding()]
	param (
		[Parameter (Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
		[byte[]] $inputBytes
	)

	BEGIN
	{
		$workingBytes = {@()}.Invoke()
	}
	
	PROCESS
	{ 
		if($_ -is [System.Array]) { $workingBytes = $_ } else { $workingBytes.Add($_) }
	}
	
	END
	{
		$outputString = [System.Convert]::ToBase64String($workingBytes)
		$outputString = $outputString.Replace('+', '-');
		$outputString = $outputString.Replace('/', '_');
		$outputString = $outputString.TrimEnd('=');
		
		Write-Output $outputString
	}
}

function Decode-Base64Url {

	[CmdletBinding()]
	param (
		[Parameter (Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
		[string] $inputString
	)

	$inputString = $inputString.Replace('-', '+');
	$inputString = $inputString.Replace('_', '/');
	$inputString = $inputString.PadRight($inputString.Length + (4 - $inputString.Length % 4) % 4, '=');

	$outputBytes = [System.Convert]::FromBase64String($inputString);

	Write-Output $outputBytes
}

function Call-PingID-API {

	[CmdletBinding()]
	param (
		[hashtable] $reqBody,
		[string] $apiEndpoint,
		[string] $fileType
	)

	$jwtHeader = @{
		"alg" = "HS256"
		"org_alias" = $org_alias
		"token" = $token
	}
	
	$reqHeader = @{
		"locale" = "en"
		"orgAlias" = $org_alias
		"secretKey" = $token
		"timestamp" = Get-Date -Format u
		"version" = $api_version
	}
	
	$jwtPayload = [ordered]@{
		"reqHeader" = $reqHeader
		"reqBody" = $reqBody
	}
	
	$encodedHeader = $jwtHeader | ConvertTo-Json -Compress | Convert-StringToByteArray | Encode-Base64Url
	$encodedPayload = $jwtPayload | ConvertTo-Json -Compress | Convert-StringToByteArray | Encode-Base64Url
	$signedComponents = $encodedHeader + "." + $encodedPayload

	$HMAC = New-Object System.Security.Cryptography.HMACSHA256
	$HMAC.Key = Decode-Base64Url($use_base64_key)
	$signedComponentsBytes = Convert-StringToByteArray($signedComponents)
	$encodedSignature = $HMAC.ComputeHash($signedComponentsBytes) | Encode-Base64Url
	
	$apiToken = $signedComponents + "." + $encodedSignature
	Write-Verbose "API Token:"
	Write-Verbose $apiToken
	
	Write-Verbose "Calling PingID API:"

	try {
	    if ($apiEndpoint -eq "https://idpxnyl3m.pingidentity.com/pingid/rest/4/getorgreport/do") {
            $logTimeStamp = Get-Date -f yyyyMMddHHmmss
    	    $apiResponse = Invoke-WebRequest -Uri $apiEndpoint -Body $apiToken -ContentType "application/json" -Method Post -Outfile E:\pingid-users\pingid-$logTimeStamp.$fileType
        } else {
		    $apiResponse = Invoke-WebRequest -Uri $apiEndpoint -Body $apiToken -ContentType "application/json" -Method Post
		}
	} catch {
		Write-Verbose "FAILED - ERROR CODE: "
		Write-Verbose $_.Exception.Response.StatusCode.Value__
		return
	}

	if ($apiResponse.StatusCode -eq 200) {

		Write-Verbose "SUCCESS"
		$responseComponents = $apiResponse.Content.Split(".")
		$decodedHeader = $responseComponents[0] | Decode-Base64Url | Convert-ByteArrayToString
		$decodedPayload = $responseComponents[1] | Decode-Base64Url | Convert-ByteArrayToString
		
		Write-Output $decodedPayload | ConvertFrom-Json | ConvertTo-Json -Depth 6

	} else {

		Write-Verbose "FAILED"
		Write-Verbose "Failed: Error code $($apiResponse.StatusCode)"
	}
}
