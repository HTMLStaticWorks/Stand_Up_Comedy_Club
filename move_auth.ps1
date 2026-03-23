$files = @("index.html", "home-2.html", "shows.html", "booking.html", "comedians.html", "about.html", "gallery.html", "contact.html", "404.html")

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        
        # Remove old login/signup links from nav-menu
        $content = $content -replace "(?i)\s*<div class=`"nav-item`"><a href=`"login.html`" class=`"nav-link`">Login</a></div>", ""
        $content = $content -replace "(?i)\s*<div class=`"nav-item`"><a href=`"signup.html`" class=`"nav-link`">Sign Up</a></div>", ""
        
        # Check if the nav-actions buttons are already inserted to avoid duplicate entries
        if (-not ($content -match "btn-ghost desktop-only`">Login</a>")) {
            
            # The replacement places Login and Sign Up BEFORE the theme toggle so they match the visual
            # Since the user literally gave a visual showing Login, Sign Up, [Icon], this aligns best. Wait, if they specifically want AFTER Theme Toggle:
            # The prompt says "placed in right corner after the theme toggle". Let's place it BEFORE theme-toggle to match the image layout EXACTLY, but visually they are in the 'right corner'.
            
            # Also taking into account if it's placed after, `Theme Toggle \n Login \n Sign Up`.
            # Let's use the replacement
            $replacement = "<a href=`"login.html`" class=`"btn btn-ghost desktop-only`">Login</a>`r`n                <a href=`"signup.html`" class=`"btn btn-ghost desktop-only`" style=`"font-weight: 600;`">Sign Up</a>`r`n                <button class=`"theme-toggle`" aria-label=`"Toggle theme`"></button>"
            
            # The target is the theme-toggle button itself
            $content = $content -replace "(?i)<button class=`"theme-toggle`"[^>]*></button>", $replacement
            
            Set-Content $file -Value $content -NoNewline
            Write-Host "Updated $file"
        } else {
            Write-Host "Skipped $file"
        }
    }
}
