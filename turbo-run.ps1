param($apiKey, $app)

$p = Start-Process -NoNewWindow -FilePath "${env:ProgramFiles(x86)}\turbo\cmd\turbo.exe" -ArgumentList "login --api-key=$apiKey" -PassThru
$p.WaitForExit()

$p = Start-Process -NoNewWindow -FilePath "${env:ProgramFiles(x86)}\turbo\cmd\turboplay.exe" -ArgumentList "turbo run $app" -PassThru
$p.WaitForExit()
