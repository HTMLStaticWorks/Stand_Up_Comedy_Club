$files = @("index.html", "home-2.html", "shows.html", "booking.html", "comedians.html", "about.html", "gallery.html", "contact.html", "404.html")
foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        
        # Check if login.html is already in the file (to avoid duplicates)
        if (-not ($content -match "href=`"login.html`" class=`"nav-link`"")) {
            # Find the contact nav item and append Login and Sign Up
            $content = $content -replace "(?i)(<div class=`"nav-item`">\s*<a href=`"contact.html`"[^>]+>Contact</a>\s*</div>)", "`$1`r`n                <div class=`"nav-item`"><a href=`"login.html`" class=`"nav-link`">Login</a></div>`r`n                <div class=`"nav-item`"><a href=`"signup.html`" class=`"nav-link`">Sign Up</a></div>"
            
            Set-Content $file -Value $content -NoNewline
            Write-Host "Updated $file"
        } else {
            Write-Host "Skipped $file (Already updated)"
        }
    }
}
