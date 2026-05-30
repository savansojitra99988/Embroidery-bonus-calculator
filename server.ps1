# Local server for Stitch Bonus Calculator (required for app install & offline mode)
$Port = 8765
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path

# Exit if port already in use (server already running)
try {
  $client = New-Object System.Net.Sockets.TcpClient
  $client.Connect("127.0.0.1", $Port)
  $client.Close()
  exit 0
} catch {}

$Mime = @{
  ".html" = "text/html; charset=utf-8"
  ".js"   = "application/javascript; charset=utf-8"
  ".json" = "application/json; charset=utf-8"
  ".svg"  = "image/svg+xml"
  ".png"  = "image/png"
  ".ico"  = "image/x-icon"
  ".zip"  = "application/zip"
  ".bat"  = "application/octet-stream"
  ".ps1"  = "text/plain; charset=utf-8"
}

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://127.0.0.1:${Port}/")
$listener.Start()

while ($listener.IsListening) {
  try {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response

    $relative = [Uri]::UnescapeDataString($request.Url.LocalPath).TrimStart("/")
    if ([string]::IsNullOrWhiteSpace($relative)) { $relative = "index.html" }

    $safePath = $relative -replace "/", [IO.Path]::DirectorySeparatorChar
    $filePath = [IO.Path]::GetFullPath((Join-Path $Root $safePath))

    if (-not $filePath.StartsWith($Root, [StringComparison]::OrdinalIgnoreCase)) {
      $response.StatusCode = 403
      $response.Close()
      continue
    }

    if (Test-Path $filePath -PathType Leaf) {
      $ext = [IO.Path]::GetExtension($filePath).ToLower()
      $response.ContentType = $Mime[$ext]
      if (-not $response.ContentType) { $response.ContentType = "application/octet-stream" }

      $bytes = [IO.File]::ReadAllBytes($filePath)
      $response.ContentLength64 = $bytes.Length
      $response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
      $response.StatusCode = 404
      $notFound = [Text.Encoding]::UTF8.GetBytes("404 Not Found")
      $response.OutputStream.Write($notFound, 0, $notFound.Length)
    }

    $response.Close()
  } catch {
    break
  }
}
