$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Add-Type -AssemblyName System.Drawing

function Draw-Icon($size) {
  $bmp = New-Object System.Drawing.Bitmap $size, $size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.Clear([System.Drawing.Color]::FromArgb(28, 28, 30))

  $screenBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(10, 15, 10))
  $g.FillRectangle($screenBrush, [int]($size * 0.1), [int]($size * 0.12), [int]($size * 0.8), [int]($size * 0.32))

  $greenBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(74, 222, 128))
  $fontSize = [int]($size * 0.14)
  $font = New-Object System.Drawing.Font("Segoe UI", $fontSize, [System.Drawing.FontStyle]::Bold)
  $g.DrawString("BONUS", $font, $greenBrush, [int]($size * 0.22), [int]($size * 0.2))

  $keyBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(58, 58, 60))
  $keySize = [int]($size * 0.14)
  $y = [int]($size * 0.58)
  for ($i = 0; $i -lt 3; $i++) {
    $x = [int]($size * (0.18 + $i * 0.28))
    $g.FillEllipse($keyBrush, $x, $y, $keySize, $keySize)
  }

  $g.Dispose()
  return $bmp
}

$bmp192 = Draw-Icon 192
$bmp512 = Draw-Icon 512
$bmp192.Save((Join-Path $Root "icon-192.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$bmp512.Save((Join-Path $Root "icon-512.png"), [System.Drawing.Imaging.ImageFormat]::Png)

$icon = [System.Drawing.Icon]::FromHandle($bmp192.GetHicon())
$fs = [IO.File]::Open((Join-Path $Root "icon.ico"), [IO.FileMode]::Create)
$icon.Save($fs)
$fs.Close()

$bmp192.Dispose()
$bmp512.Dispose()
Write-Host "Icons created."
