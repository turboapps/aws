#
# usage: setup-turbo-client.ps1 [domain] [appBlockName] [vhdName]
#   domain - url of turbo server domain to configure the client to
#   vhdFilePath - the path to the vhd file which contains the turbo client installation.
#
param($domain, $vhdFilePath="C:\AppStream\AppBlocks\turbo-client\turbo-client.vhd")

function Trace([string]$msg)
{
    $clientDir = Join-Path ${env:ProgramFiles(x86)} "Turbo"
    
    if(-not (Test-Path $clientDir))
    {
        New-Item $clientDir -ItemType Directory
    }
    
    $logPath = Join-Path $clientDir "setup-turbo-client-log.txt"

    $timestamp = "{0:MM/dd/yy} {0:HH:mm:ss}" -f (Get-Date)
    "$timestamp - $msg" >> $logPath 

    Write-Output $msg
}


# write diskpart script to attach the vhd
# note: the encoding must be utf8 or else diskpart fails to consume it. 
#       for this reason, can't use the powershell io redirection operator.
Trace("Start attaching $vhdFilePath...");

$attachScriptPath = Join-Path $env:TEMP "attach.txt"
$mountPath="f:" # why "f:"? some rule or can be anything?
Out-File $attachScriptPath -Encoding utf8 -InputObject "select vdisk file='$vhdFilePath'"
Out-File $attachScriptPath -Encoding utf8 -Append -InputObject "attach vdisk" 
Out-File $attachScriptPath -Encoding utf8 -Append -InputObject "select partition 1"
Out-File $attachScriptPath -Encoding utf8 -Append -InputObject "remove all noerr" 
Out-File $attachScriptPath -Encoding utf8 -Append -InputObject "assign mount='$mountPath'" 
Out-File $attachScriptPath -Encoding utf8 -Append -InputObject "exit"

# execute diskpart script
diskpart /s $attachScriptPath

rm $attachScriptPath

# complete client installation
Trace("Start installing client...");
$installDir = "$mountPath\turbo-client"

$args = "--silent --all-users --domain=$domain --add-trusted-source=$domain"
$args += " --no-files --install-dir=$installDir" # comment this line for slow/complete client install

$p = Start-Process -NoNewWindow -FilePath "$installDir\turbo-client.exe" -ArgumentList $args -PassThru
$p.WaitForExit()

# all done
Trace("Turbo client environment prep is complete.");
