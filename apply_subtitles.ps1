$files = @(
    @{ 
        file = "about.html"
        oldTitle = "About Us"
        newTitle = "About Our Comedy Club"
        subtitle = "Building the greatest stage for comedy, one punchline at a time. Learn about our story, our mission, and the team behind the laughs."
    },
    @{ 
        file = "shows.html"
        oldTitle = "Shows & Events"
        newTitle = "Upcoming Shows"
        subtitle = "Browse our interactive calendar to secure your tickets for upcoming open mics, nationally touring headliners, and legendary secret drop-ins."
    },
    @{ 
        file = "comedians.html"
        oldTitle = "Our Comedians" # From my previous script, I specifically used "Our Comedians"
        newTitle = "Our Comedians"
        subtitle = "Meet the incredibly talented people who bring laughter to our stage every week. From nationally recognized stars to local legends."
    },
    @{ 
        file = "contact.html"
        oldTitle = "Contact Us"
        newTitle = "Get in Touch"
        subtitle = "Have a question about tickets, booking a private event, or performing at our open mic? Our team is always here to help."
    },
    @{ 
        file = "gallery.html"
        oldTitle = "Gallery"
        newTitle = "The Venue in Action"
        subtitle = "A glimpse into the energy, laughter, and unbelievable nights. Browse our gallery of past shows, comedians, and the vibrant atmosphere."
    },
    @{ 
        file = "booking.html"
        oldTitle = "Secure Check Out"
        newTitle = "Secure Check Out"
        subtitle = "Complete your purchase details below to lock in an evening of premium laughter."
    },
    @{ 
        file = "404.html"
        oldTitle = "Page Not Found"
        newTitle = "Page Not Found"
        subtitle = "Like a comedian bombing on stage, it just didn't work out. Let's get you back on track."
    },
    @{ 
        file = "coming-soon.html"
        oldTitle = "Coming Soon"
        newTitle = "Coming Soon"
        subtitle = "Our team is working hard behind the scenes writing some fresh material. We'll be back shortly!"
    }
)

foreach ($f in $files) {
    if (Test-Path $f.file) {
        $content = Get-Content $f.file -Raw
        
        # We need to replace:
        # <h1 class="page-hero-title">OLD TITLE</h1>
        # With:
        # <h1 class="page-hero-title">NEW TITLE</h1>
        # <p class="subtitle">SUBTITLE</p>
        
        $pattern = "<h1 class=`"page-hero-title`">$($f.oldTitle)</h1>"
        $replacement = "<h1 class=`"page-hero-title`">$($f.newTitle)</h1>`r`n                <p class=`"subtitle`">$($f.subtitle)</p>"
        
        # If already replaced, skip to avoid double p tags
        if ($content -notmatch "<p class=`"subtitle`">$($f.subtitle)</p>") {
            $content = $content -replace $pattern, $replacement
            Set-Content $f.file -Value $content -NoNewline
            Write-Host "Updated $($f.file)"
        } else {
            Write-Host "Skipped $($f.file) - already has subtitle."
        }
    }
}
