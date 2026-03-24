$htmlFiles = @(
    "index.html", "about.html", "shows.html", 
    "comedians.html", "booking.html", "gallery.html", 
    "contact.html", "404.html", "home-2.html", "signup.html", "login.html"
)

# New Navigation Menu (Clean, including Home 2)
$navMenuTemplate = @"
            <nav class="nav-menu" aria-label="Main Navigation">
                <div class="nav-item"><a href="index.html" class="nav-link [[ACTIVE_INDEX]]">Home</a></div>
                <div class="nav-item"><a href="home-2.html" class="nav-link [[ACTIVE_HOME2]]">Home 2</a></div>
                <div class="nav-item"><a href="shows.html" class="nav-link [[ACTIVE_SHOWS]]">Shows</a></div>
                <div class="nav-item"><a href="booking.html" class="nav-link [[ACTIVE_BOOKING]]">Booking</a></div>
                <div class="nav-item"><a href="comedians.html" class="nav-link [[ACTIVE_COMEDIANS]]">Comedians</a></div>
                <div class="nav-item"><a href="about.html" class="nav-link [[ACTIVE_ABOUT]]">About</a></div>
                <div class="nav-item"><a href="contact.html" class="nav-link [[ACTIVE_CONTACT]]">Contact</a></div>
                <div class="nav-item mobile-only"><a href="login.html" class="nav-link [[ACTIVE_LOGIN]]">Login</a></div>
                <div class="nav-item mobile-only"><a href="signup.html" class="nav-link [[ACTIVE_SIGNUP]]">Sign Up</a></div>
            </nav>
"@

# New Navigation Actions
$navActionsTemplate = @"
            <div class="nav-actions">
                <button class="theme-toggle" aria-label="Toggle theme"></button>
                <button class="rtl-toggle" aria-label="Toggle RTL mode">RTL</button>

                <a href="login.html" class="btn btn-outline desktop-only">Login</a>
                <a href="signup.html" class="btn btn-primary desktop-only">Sign Up</a>
                <button class="hamburger" aria-expanded="false" aria-label="Toggle navigation menu"
                    aria-controls="navbar-menu">
                    <span></span>
                    <span></span>
                    <span></span>
                </button>
            </div>
"@

foreach ($file in $htmlFiles) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        
        $fileNav = $navMenuTemplate
        
        $valIndex = if ($file -eq "index.html") { "active" } else { "" }
        $fileNav = $fileNav.Replace("[[ACTIVE_INDEX]]", $valIndex)

        $valHome2 = if ($file -eq "home-2.html") { "active" } else { "" }
        $fileNav = $fileNav.Replace("[[ACTIVE_HOME2]]", $valHome2)
        
        $valShows = if ($file -eq "shows.html") { "active" } else { "" }
        $fileNav = $fileNav.Replace("[[ACTIVE_SHOWS]]", $valShows)
        
        $valBooking = if ($file -eq "booking.html") { "active" } else { "" }
        $fileNav = $fileNav.Replace("[[ACTIVE_BOOKING]]", $valBooking)
        
        $valComedians = if ($file -eq "comedians.html") { "active" } else { "" }
        $fileNav = $fileNav.Replace("[[ACTIVE_COMEDIANS]]", $valComedians)
        
        $valAbout = if ($file -eq "about.html") { "active" } else { "" }
        $fileNav = $fileNav.Replace("[[ACTIVE_ABOUT]]", $valAbout)
        
        $valContact = if ($file -eq "contact.html") { "active" } else { "" }
        $fileNav = $fileNav.Replace("[[ACTIVE_CONTACT]]", $valContact)
        
        $valLogin = if ($file -eq "login.html") { "active" } else { "" }
        $fileNav = $fileNav.Replace("[[ACTIVE_LOGIN]]", $valLogin)
        
        $valSignup = if ($file -eq "signup.html") { "active" } else { "" }
        $fileNav = $fileNav.Replace("[[ACTIVE_SIGNUP]]", $valSignup)
        
        $navPattern = "(?s)<nav class=`"nav-menu`"[^>]*>.*?</nav>"
        $content = $content -replace $navPattern, $fileNav
        
        $actionsPattern = "(?s)<div class=`"nav-actions`"[^>]*>.*?</div>"
        $content = $content -replace $actionsPattern, $navActionsTemplate
        
        Set-Content $file -Value $content -NoNewline
        Write-Host "Updated $file"
    }
}
