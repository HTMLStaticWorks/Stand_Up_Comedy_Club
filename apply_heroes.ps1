$pages = @(
    @{ file="about.html"; title="About Us"; titleText="About Us"; img="https://images.unsplash.com/photo-1516280440502-a2989cb51d15?auto=format&fit=crop&w=1920&q=80"; target="(?s)<section class=`"about-hero`">.*?</section>" },
    @{ file="shows.html"; title="Shows & Tickets"; titleText="Shows"; img="https://images.unsplash.com/photo-1585699324551-f6c309eedeca?auto=format&fit=crop&w=1920&q=80"; target="(?s)<section class=`"section`"[^>]*>.*?Explore Our Shows.*?</section>" },
    @{ file="comedians.html"; title="Our Comedians"; titleText="Comedians"; img="https://images.unsplash.com/photo-1543007630-9710e4a00a20?auto=format&fit=crop&w=1920&q=80"; target="(?s)<section class=`"section`"[^>]*>.*?The Lineup.*?</section>" },
    @{ file="contact.html"; title="Contact Us"; titleText="Contact"; img="https://images.unsplash.com/photo-1498842812179-c81beecf902c?auto=format&fit=crop&w=1920&q=80"; target="(?s)<section class=`"section`"[^>]*>.*?Get in Touch.*?</section>" },
    @{ file="gallery.html"; title="Gallery"; titleText="Gallery"; img="https://images.unsplash.com/photo-1478147427282-58a87a120781?auto=format&fit=crop&w=1920&q=80"; target="(?s)<section class=`"section`"[^>]*>.*?The Venue in Action.*?</section>" }
)

foreach ($p in $pages) {
    if (Test-Path $p.file) {
        $content = Get-Content $p.file -Raw
        $heroHtml = @"
        <!-- Global Hero Section -->
        <section class="page-hero" style="background-image: url('$($p.img)');">
            <div class="container page-hero-content">
                <h1 class="page-hero-title">$($p.title)</h1>
                <div class="breadcrumb"><a href="index.html">Home</a> &gt; <span>$($p.titleText)</span></div>
            </div>
        </section>
"@
        $content = $content -replace $p.target, $heroHtml
        Set-Content $p.file -Value $content -NoNewline
        Write-Host "Updated $($p.file)"
    }
}

# Special handling for booking.html 
if (Test-Path "booking.html") {
    $content = Get-Content "booking.html" -Raw
    $heroHtml = @"
    <main>
        <section class="page-hero" style="background-image: url('https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=1920&q=80'); margin-bottom: var(--space-6);">
            <div class="container page-hero-content">
                <h1 class="page-hero-title">Secure Check Out</h1>
                <div class="breadcrumb"><a href="index.html">Home</a> &gt; <a href="shows.html">Shows</a> &gt; <span>Booking</span></div>
            </div>
        </section>
        <section class="section" style="padding-top: 0;">
            <div class="container booking-container">
"@
    
    # booking had: <main class="section"><div class="container booking-container"><h1 class="text-center" ...>Secure Your Spot</h1>
    $content = $content -replace "(?s)<main class=`"section`">\s*<div class=`"container booking-container`">\s*<h1 class=`"text-center`"[^>]*>Secure Your Spot</h1>", $heroHtml
    
    Set-Content "booking.html" -Value $content -NoNewline
    Write-Host "Updated booking.html"
}

# Add hero to 404
if (Test-Path "404.html") {
    $content = Get-Content "404.html" -Raw
    $heroHtml = @"
    <main id="main-content" style="display: flex; flex-direction: column; min-height: calc(100vh - var(--navbar-height)); padding: 0;">
        <section class="page-hero" style="background-image: url('https://images.unsplash.com/photo-1510363283281-19ce776e05d3?auto=format&fit=crop&w=1920&q=80'); margin-bottom: 0;">
            <div class="container page-hero-content">
                <h1 class="page-hero-title">Page Not Found</h1>
                <div class="breadcrumb"><a href="index.html">Home</a> &gt; <span>404</span></div>
            </div>
        </section>
        <div class="error-page" style="flex: 1; margin: 0; min-height: 0;">
"@
    $content = $content -replace "(?s)<main id=`"main-content`" class=`"error-page`">", $heroHtml
    # Fix the closing tags: error-page needs to close before main
    $content = $content -replace "(?s)</main>", "        </div>`r`n    </main>"
    
    Set-Content "404.html" -Value $content -NoNewline
    Write-Host "Updated 404.html"
}

# Add hero to coming-soon
if (Test-Path "coming-soon.html") {
    $content = Get-Content "coming-soon.html" -Raw
    $heroHtml = @"
    <main id="main-content" style="padding: 0;">
        <section class="page-hero" style="background-image: url('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=1920&q=80'); margin-bottom: 0;">
            <div class="container page-hero-content">
                <h1 class="page-hero-title">Coming Soon</h1>
                <div class="breadcrumb"><a href="index.html">Home</a> &gt; <span>Coming Soon</span></div>
            </div>
        </section>
"@
    # Only replace once if it exists
    if ($content -notmatch "page-hero") {
        $content = $content -replace '(?s)<main id="main-content"[^>]*>', $heroHtml
        Set-Content "coming-soon.html" -Value $content -NoNewline
        Write-Host "Updated coming-soon.html"
    } else {
        Write-Host "Skipped coming-soon.html (already updated)"
    }
}
