﻿param($domain)

rm "$env:TEMP\attach2.txt" -ErrorAction Ignore
Out-File "$env:TEMP\attach2.txt" -InputObject "select vdisk file='C:\AppStream\AppBlocks\turbo-client\turbo-client.vhd'" -Encoding utf8 -Append
Out-File "$env:TEMP\attach2.txt" -InputObject "attach vdisk" -Encoding utf8 -Append
Out-File "$env:TEMP\attach2.txt" -InputObject "select partition 1" -Encoding utf8 -Append
Out-File "$env:TEMP\attach2.txt" -InputObject "remove all noerr" -Encoding utf8 -Append
Out-File "$env:TEMP\attach2.txt" -InputObject "assign mount='d:'" -Encoding utf8 -Append
Out-File "$env:TEMP\attach2.txt" -InputObject "exit" -Encoding utf8 -Append
diskpart /s $env:TEMP\attach2.txt
$env:TEMP
$p = Start-Process -NoNewWindow -FilePath "d:\turbo-client-21.10.2402.0.exe" -ArgumentList "--silent --all-users --domain=$domain --add-trusted-source=$domain" -PassThru
$p.WaitForExit()