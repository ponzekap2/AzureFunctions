# Input bindings are passed in via param block.
param($Timer)

# Get the current universal time in the default string format
$currentUTCtime = (Get-Date).ToUniversalTime()

# The 'IsPastDue' porperty is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}

$Openssl = openssl s_client -connect "sipdir.online.lync.com:5061" 2>/dev/null | openssl x509 -noout -dates

## Fix the date
$Openssl[0] -replace "notBefore=",""


<## Format
notBefore=Oct 31 00:00:00 2013 GMT
So, first we need to remove the notBefore= part:

dateStr=${NotBeforeDate/notBefore=/}
Then you can use the date command:

date --date="$dateStr" --utc +"%m-%d-%Y"


date --date="$(echo | openssl s_client -connect sipdir.online.lync.com:5061 | openssl x509 -noout -enddate | awk -F '=' '{print $NF}' )" --iso-8601
#>

# Write an information log with the current time.
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"
