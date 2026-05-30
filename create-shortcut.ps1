$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Launcher = Join-Path $Root "Launch App.bat"
$Icon = Join-Path $Root "icon.ico"
$Desktop = [Environment]::GetFolderPath("Desktop")
$ShortcutPath = Join-Path $Desktop "Stitch Bonus Calculator.lnk"

if (-not (Test-Path $Icon)) {
  & (Join-Path $Root "generate-icons.ps1")
}

$Wsh = New-Object -ComObject WScript.Shell
$Sc = $Wsh.CreateShortcut($ShortcutPath)
$Sc.TargetPath = $Launcher
$Sc.WorkingDirectory = $Root
$Sc.WindowStyle = 1
$Sc.Description = "Garment production stitch bonus calculator"
if (Test-Path $Icon) { $Sc.IconLocation = $Icon }
$Sc.Save()

Write-Host "Shortcut created: $ShortcutPath"
