document.addEventListener('DOMContentLoaded', () => {
    // ---------------------------------------------------------
    // 1. RTL Toggle System (Hardened Event Delegation)
    // ---------------------------------------------------------
    const syncRTL = (isRTL) => {
        const dir = isRTL ? 'rtl' : 'ltr';
        document.documentElement.setAttribute('dir', dir);
        document.documentElement.dir = dir;
        document.body.setAttribute('dir', dir);
        document.body.dir = dir;

        document.querySelectorAll('.rtl-toggle').forEach(btn => {
            btn.classList.toggle('active', isRTL);
        });

        localStorage.setItem('rtl_pref', isRTL ? 'true' : 'false');
    };

    // Load and Apply RTL Preference
    const savedRTL = localStorage.getItem('rtl_pref') === 'true';
    syncRTL(savedRTL);

    // Global Click Listener for RTL Toggles
    document.addEventListener('click', (e) => {
        const btn = e.target.closest('.rtl-toggle');
        if (btn) {
            e.preventDefault();
            const currentlyRTL = document.documentElement.getAttribute('dir') === 'rtl';
            syncRTL(!currentlyRTL);
        }
    });

    // ---------------------------------------------------------
    // 2. Theme Toggle System (Reliability Fix)
    // ---------------------------------------------------------
    const updateThemeIcon = (theme) => {
        const themeToggle = document.querySelector('.theme-toggle');
        if (!themeToggle) return;

        if (theme === 'dark') {
            themeToggle.innerHTML = `<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><circle cx="12" cy="12" r="5"></circle><line x1="12" y1="1" x2="12" y2="3"></line><line x1="12" y1="21" x2="12" y2="23"></line><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line><line x1="1" y1="12" x2="3" y2="12"></line><line x1="21" y1="12" x2="23" y2="12"></line><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line></svg><span class="sr-only">Toggle Light Mode</span>`;
        } else {
            themeToggle.innerHTML = `<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path></svg><span class="sr-only">Toggle Dark Mode</span>`;
        }
    };

    const setTheme = (theme) => {
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem('theme', theme);
        updateThemeIcon(theme);
    };

    // Load and Apply Theme Preference
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)');
    const savedTheme = localStorage.getItem('theme') || (prefersDark.matches ? 'dark' : 'light');
    setTheme(savedTheme);

    // Global Click Listener for Theme Toggles
    document.addEventListener('click', (e) => {
        const btn = e.target.closest('.theme-toggle');
        if (btn) {
            e.preventDefault();
            const currentTheme = document.documentElement.getAttribute('data-theme');
            setTheme(currentTheme === 'dark' ? 'light' : 'dark');
        }
    });

    // ---------------------------------------------------------
    // 3. Navigation & Miscellaneous
    // ---------------------------------------------------------
    const hamburger = document.querySelector('.hamburger');
    const navMenu = document.querySelector('.nav-menu');
    const navLinks = document.querySelectorAll('.nav-link');

    if (hamburger && navMenu) {
        hamburger.addEventListener('click', () => {
            const isActive = hamburger.classList.toggle('active');
            navMenu.classList.toggle('active');
            hamburger.setAttribute('aria-expanded', isActive);
            navMenu.setAttribute('aria-hidden', !isActive);
        });

        // Close menu when a link is clicked
        document.addEventListener('click', (e) => {
            if (e.target.closest('.nav-link')) {
                hamburger.classList.remove('active');
                navMenu.classList.remove('active');
            }
        });
    }

    // Skeleton Loader Simulation
    const skeletonElements = document.querySelectorAll('.skeleton');
    if (skeletonElements.length > 0) {
        setTimeout(() => {
            skeletonElements.forEach(el => el.classList.remove('skeleton'));
        }, 1500);
    }

  // Newsletter Form Simulation
  const newsletterForm = document.getElementById('newsletter-form');
  if (newsletterForm) {
    newsletterForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const emailInput = newsletterForm.querySelector('input[type="email"]');
      const submitBtn = newsletterForm.querySelector('button[type="submit"]');
      const originalText = submitBtn.innerHTML;
      
      if(emailInput.value) {
        submitBtn.innerHTML = 'Subscribing...';
        submitBtn.disabled = true;
        
        // Simulate API call
        setTimeout(() => {
          submitBtn.innerHTML = 'Subscribed!';
          submitBtn.classList.remove('btn-primary');
          submitBtn.style.backgroundColor = 'var(--success)';
          emailInput.value = '';
          
          setTimeout(() => {
            submitBtn.innerHTML = originalText;
            submitBtn.disabled = false;
            submitBtn.style.backgroundColor = '';
            submitBtn.classList.add('btn-primary');
          }, 3000);
        }, 1500);
      }
    });
  }
  // Scroll to Top Functionality
  const createScrollTopBtn = () => {
    // Exclude from login/signup pages
    const path = window.location.pathname;
    if (path.includes('login.html') || path.includes('signup.html')) return;

    const btn = document.createElement('button');
    btn.className = 'scroll-top-btn';
    btn.setAttribute('aria-label', 'Scroll to top');
    btn.innerHTML = `<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="18 15 12 9 6 15"></polyline></svg>`;
    document.body.appendChild(btn);

    window.addEventListener('scroll', () => {
      if (window.pageYOffset > 300) {
        btn.classList.add('visible');
      } else {
        btn.classList.remove('visible');
      }
    });

    btn.addEventListener('click', () => {
      window.scrollTo({
        top: 0,
        behavior: 'smooth'
      });
    });
  };

  createScrollTopBtn();

  /* RTL logic moved to top */
});
