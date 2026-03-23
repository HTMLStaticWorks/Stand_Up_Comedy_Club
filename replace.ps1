$files = @(
    "index.html", "home-2.html", "shows.html", "booking.html", 
    "comedians.html", "about.html", "gallery.html", "contact.html", 
    "404.html", "coming-soon.html", "dashboard\admin.html", "dashboard\user.html"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        $isDash = $file -match "dashboard"
        $logo = if ($isDash) {"../assets/logo/logo-transparent.svg"} else {"assets/logo/logo-transparent.svg"}
        $fav = if ($isDash) {"../assets/logo/favicon-32x32.svg"} else {"assets/logo/favicon-32x32.svg"}

        # Replace 1: Favicon
        if (-not ($content -match "rel=`"icon`"")) {
            $content = $content -replace "<!-- Stylesheets -->", "<link rel=`"icon`" type=`"image/svg+xml`" href=`"$fav`">`r`n    <!-- Stylesheets -->"
        }

        # Replace 2: Existing SVG
        $content = $content -replace "(?s)<svg\s+width=`"\d+`".*?</svg>", "<img src=`"$logo`" alt=`"Comedy Hub Logo`" style=`"width: 1.2em; height: 1.2em;`">"

        # Replace 3: Text-only nav-brand
        if (-not ($file -match "coming-soon")) {
            $content = $content -replace "(?s)<a([^>]*)class=`"nav-brand`"([^>]*)>The Comedy Hub</a>", "<a`$1class=`"nav-brand`"`$2>`r`n                <img src=`"$logo`" alt=`"Comedy Hub Logo`" style=`"width: 1.2em; height: 1.2em;`">`r`n                The Comedy Hub`r`n            </a>"
        }
        
        # Replace 4: The Hub missing nav-brand (on comedians page I might have written 'The Hub')
        $content = $content -replace "(?s)<a([^>]*)class=`"nav-brand`"([^>]*)>The Hub</a>", "<a`$1class=`"nav-brand`"`$2>`r`n                <img src=`"$logo`" alt=`"Comedy Hub Logo`" style=`"width: 1.2em; height: 1.2em;`">`r`n                The Comedy Hub`r`n            </a>"

        Set-Content $file -Value $content -NoNewline
        Write-Host "Updated $file"
    }
}
