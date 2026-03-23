$files = @("index.html", "home-2.html", "shows.html", "booking.html", "comedians.html", "about.html", "gallery.html", "contact.html", "404.html")

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        
        # We want to ensure Login and Signup are strictly the LAST action items before the hamburger menu.
        # This places them in the absolute right corner of the navbar actions, solving any positioning conflicts.
        
        # 1. Strip out the desktop-only buttons from wherever they are in the nav-actions right now
        $content = $content -replace "(?i)\s*<a href=`"login.html`" class=`"btn btn-outline desktop-only`">Login</a>", ""
        $content = $content -replace "(?i)\s*<a href=`"signup.html`" class=`"btn btn-primary desktop-only`">Sign Up</a>", ""
        
        # 2. Insert them immediately before the hamburger button
        $replacement = "<a href=`"login.html`" class=`"btn btn-outline desktop-only`">Login</a>`r`n                <a href=`"signup.html`" class=`"btn btn-primary desktop-only`">Sign Up</a>`r`n                <button class=`"hamburger`""
        
        $content = $content -replace "(?i)<button class=`"hamburger`"", $replacement
        
        Set-Content $file -Value $content -NoNewline
        Write-Host "Updated $file"
    }
}
