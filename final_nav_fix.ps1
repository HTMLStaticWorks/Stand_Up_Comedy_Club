$files = @("index.html", "home-2.html", "shows.html", "booking.html", "comedians.html", "about.html", "gallery.html", "contact.html", "404.html")

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        
        # Strip previously added links anywhere
        $content = $content -replace "(?i)\s*<a href=`"login.html`"[^>]*>Login</a>", ""
        $content = $content -replace "(?i)\s*<a href=`"signup.html`"[^>]*>Sign Up</a>", ""
        $content = $content -replace "(?i)\s*<div class=`"nav-item mobile-only`"><a href=`"login.html`"[^>]*>Login</a></div>", ""
        $content = $content -replace "(?i)\s*<div class=`"nav-item mobile-only`"><a href=`"signup.html`"[^>]*>Sign Up</a></div>", ""

        # Build replacement for nav-actions (placed AFTER theme-toggle)
        $newBtns = "<button class=`"theme-toggle`" aria-label=`"Toggle theme`"></button>`r`n                <a href=`"login.html`" class=`"btn btn-outline desktop-only`">Login</a>`r`n                <a href=`"signup.html`" class=`"btn btn-primary desktop-only`">Sign Up</a>"
        
        # Replace the theme toggle
        $content = $content -replace "(?i)<button class=`"theme-toggle`"[^>]*></button>", $newBtns
        
        # Build replacement for nav-menu (placed BEFORE </nav>)
        # Only if the file actually has a nav-menu (booking.html does not)
        if ($content -match "</nav>") {
            $newMobileLinks = "    <div class=`"nav-item mobile-only`"><a href=`"login.html`" class=`"nav-link`">Login</a></div>`r`n                <div class=`"nav-item mobile-only`"><a href=`"signup.html`" class=`"nav-link`">Sign Up</a></div>`r`n            </nav>"
            $content = $content -replace "(?i)\s*</nav>", "`r`n            $newMobileLinks"
        }
        
        Set-Content $file -Value $content -NoNewline
        Write-Host "Updated $file"
    }
}
