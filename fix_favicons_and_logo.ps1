$htmlFiles = @(
    "index.html", "home-2.html", "about.html", "shows.html", 
    "comedians.html", "gallery.html", "contact.html", "404.html",
    "booking.html", "login.html", "signup.html", "coming-soon.html"
)

$faviconTags = @"
    <link rel="icon" type="image/svg+xml" href="assets/logo/favicon-32x32.svg">
    <link rel="icon" type="image/svg+xml" sizes="16x16" href="assets/logo/favicon-16x16.svg">
    <link rel="icon" type="image/svg+xml" sizes="48x48" href="assets/logo/favicon-48x48.svg">
"@

foreach ($file in $htmlFiles) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        
        # 1. Update Favicon Links
        # Regex to find existing icon link
        $favPattern = '(?s)<link rel="icon"[^>]*>'
        if ($content -match $favPattern) {
            $content = $content -replace $favPattern, $faviconTags
        } else {
            # If no favicon link exists, insert before </head>
            $content = $content -replace '</head>', "`n$faviconTags`n</head>"
        }

        # 2. Update Logo visibility (add .logo-img class)
        # Search for logo images in navbar/auth headers
        $logoPattern = '(<img src="assets/logo/logo-transparent\.svg" alt="[^"]*")'
        $content = $content -replace $logoPattern, '$1 class="logo-img"'

        Set-Content $file -Value $content -NoNewline
        Write-Host "Processed $file"
    }
}
