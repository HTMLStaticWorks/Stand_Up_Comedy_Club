$logoRegex = '<img src="(?:assets/)?logo/logo-transparent.svg" alt="Comedy Hub Logo" class="logo-img"\s+style="width: 1.2em; height: 1.2em;[^"]*">'
$newLogo = '<img src="assets/logo/logo-transparent.svg" alt="Comedy Hub Logo" class="logo-img">'

$files = Get-ChildItem -Recurse -Include *.html
foreach ($file in $files) {
    if ($file.Name -ne "404.html") {
        $content = Get-Content $file.FullName -Raw
        if ($content -match $logoRegex) {
            $newContent = $content -replace $logoRegex, $newLogo
            Set-Content $file.FullName $newContent -NoNewline
            Write-Host "Updated footer logo in $($file.Name)"
        }
    }
}
