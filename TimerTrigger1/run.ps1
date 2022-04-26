# Input bindings are passed in via param block.
param($Timer)

# Get the current universal time in the default string format
$currentUTCtime = (Get-Date).ToUniversalTime()

# The 'IsPastDue' porperty is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}

# Variables

$ServertoCheck = "sipdir.online.lync.com"
$Port = "5061"
$CertWarninginDays = "365"


###
$ServerConnectCommand = $servertocheck + ":" + $Port

$SSHOutput = openssl s_client -connect "sipdir.online.lync.com:5061" 2>/dev/null | openssl x509 -noout -dates



###Windows Debug
#cd "C:\Program Files\OpenSSL-Win64\bin"
#$SSHOutput = .\openssl.exe s_client -connect "$ServerConnectCommand" | .\openssl.exe x509 -noout -dates

$CurrentDate = Get-Date


$CertExpirationDate = [datetime]::ParseExact(
  ($sshoutput[1] -replace '^notAfter='), 
  'MMM d HH:mm:ss yyyy GMT',
   [cultureinfo]::InvariantCulture
) 

$DaystoCertExpiration = (New-TimeSpan -Start (Get-Date) -End $CertExpirationDate).Days

if ($DaystoCertExpiration -lt $CertWarninginDays) {Write-Host "WARNING:$($ServertoCheck) has a certificate that expires in $($DaystoCertExpiration)" }
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"
