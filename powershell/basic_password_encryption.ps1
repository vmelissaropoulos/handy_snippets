function encrypt {
    [CmdletBinding()]
    param (
        [Parameter()][string]$Password
    )
    # secure string
    if ([string]::IsNullOrEmpty($Password)) {
        $exit = $false
        do {
            $secureSTR_1 = Read-Host -Prompt "Enter password (Ctrl+C to exit)" -AsSecureString
            $secureSTR_2 = Read-Host -Prompt "Repeat password (Ctrl+C to exit)" -AsSecureString
            $secSTR_1_TXT = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureSTR_1))
            $secSTR_2_TXT = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureSTR_2))
            if ($secSTR_1_TXT -ceq $secSTR_2_TXT) {
                $secureSTR = $secureSTR_1
                $exit = $true
            }
            else {
                Write-Host "Passwords don't match! Try again.`n " -ForegroundColor Red
            }
        } until ($exit -eq $true)
    }
    else {
        $secureSTR = ConvertTo-SecureString -AsPlainText $Password -Force
    }

    
    # make it string
    $secureTEXT = ConvertFrom-SecureString -SecureString $secureSTR
    Write-Debug "Secure Text:`n$SecureTEXT"

    # encode to bytes
    $byteMe = [System.Text.Encoding]::UTF8.GetBytes($secureTEXT)

    # convert to base64
    $encodedTEXT = [System.Convert]::ToBase64String($byteMe)

    Write-Debug "`n`nEncoded Text:`n$encodedTEXT"

    return $encodedTEXT
}


function decrypt {
    [CmdletBinding()]
    param (
        [Parameter()][string]$encodedTEXT
    )

    try {
        
        # to bytes
        $byteMe = [system.convert]::FromBase64String($encodedTEXT)
        
        # to text from base64
        $secureTEXT = [System.Text.Encoding]::UTF8.GetString($byteMe)
        Write-Debug "Secure Text:`n$SecureTEXT"
        
        # to secure string from secure text
        $secureSTR = ConvertTo-SecureString -String $secureTEXT
        
        # to plain password
        $PlainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureSTR))
    }
    catch {
        $e = $_.exception
        throw $e.Message
    }

    return $PlainPassword
}


$saveThisToFile = encrypt '1qaz"WSX'
Write-host "Encrypted:`n$saveThisToFile" -ForegroundColor Green

$plain = decrypt -encodedTEXT $saveThisToFile
Write-host "Decrypted:`n$plain" -ForegroundColor Red
