# Enable credSPP

$myDomain = "lab.vm.local" # NO leading dot [.]
Enable-WSManCredSSP -Role client -DelegateComputer "*.$myDomain" -Force

$allowed = @("WSMAN/*.$myDomain")

$key = 'hklm:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation'
if (!(Test-Path $key)) {
    mkdir $key
}
New-ItemProperty -Path $key -Name AllowFreshCredentials -Value 1 -PropertyType Dword -Force            

$key = Join-Path $key 'AllowFreshCredentials'
if (!(Test-Path $key)) {
    mkdir $key
}
$i = 1
$allowed |% {
    # Script does not take into account existing entries in this key
    New-ItemProperty -Path $key -Name $i -Value $_ -PropertyType String -Force
    $i++
}

Set-Item WSMAN:\localhost\client\auth\credssp -value $true
Set-Item WSMAN:\localhost\service\auth\credssp -value $true
