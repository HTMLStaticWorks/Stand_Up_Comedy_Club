$htmlFiles = @(
    "index.html", "home-2.html", "about.html", "shows.html", 
    "comedians.html", "gallery.html", "contact.html", "404.html"
)

$newNav = @"
            <nav class="nav-menu" aria-label="Main Navigation">
                <div class="nav-item has-dropdown">
                    <a href="index.html" class="nav-link dropdown-toggle">Home</a>
                    <div class="dropdown-menu">
                        <a href="home-2.html" class="dropdown-item">Home 2</a>
                    </div>
                </div>
                <div class="nav-item"><a href="shows.html" class="nav-link">Shows</a></div>
                <div class="nav-item"><a href="booking.html" class="nav-link">Booking</a></div>
                <div class="nav-item"><a href="comedians.html" class="nav-link">Comedians</a></div>
                <div class="nav-item"><a href="about.html" class="nav-link">About</a></div>
                <div class="nav-item"><a href="contact.html" class="nav-link">Contact</a></div>
                <div class="nav-item mobile-only"><a href="login.html" class="nav-link">Login</a></div>
                <div class="nav-item mobile-only"><a href="signup.html" class="nav-link">Sign Up</a></div>
            </nav>
"@

foreach ($file in $htmlFiles) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        $pattern = '(?s)<nav class="nav-menu"[^>]*>.*?</nav>'
        if ($content -match $pattern) {
            $content = $content -replace $pattern, $newNav
            Set-Content $file -Value $content -NoNewline
            Write-Host "Updated Nav in $file"
        }
    }
}
