document.addEventListener('DOMContentLoaded', () => {
  // Mobile / Tablet Navigation Toggle
  const hamburger = document.querySelector('.hamburger');
  const navMenu = document.querySelector('.nav-menu');
  const navLinks = document.querySelectorAll('.nav-link');

  if (hamburger && navMenu) {
    hamburger.addEventListener('click', () => {
      const isActive = hamburger.classList.toggle('active');
      navMenu.classList.toggle('active');
      hamburger.setAttribute('aria-expanded', isActive);
      
      // Accessibility update
      if(isActive) {
        navMenu.setAttribute('aria-hidden', 'false');
      } else {
        navMenu.setAttribute('aria-hidden', 'true');
      }
    });

    // Close menu when a link is clicked
    navLinks.forEach(link => {
      link.addEventListener('click', () => {
        hamburger.classList.remove('active');
        navMenu.classList.remove('active');
        hamburger.setAttribute('aria-expanded', 'false');
        navMenu.setAttribute('aria-hidden', 'true');
      });
    });

    // Close menu when clicking outside
    document.addEventListener('click', (e) => {
      if (!navMenu.contains(e.target) && !hamburger.contains(e.target) && navMenu.classList.contains('active')) {
        hamburger.classList.remove('active');
        navMenu.classList.remove('active');
        hamburger.setAttribute('aria-expanded', 'false');
        navMenu.setAttribute('aria-hidden', 'true');
      }
    });
  }

  // Dark and Light Mode Toggle with System Detection
  const themeToggle = document.querySelector('.theme-toggle');
  const prefersDarkScheme = window.matchMedia('(prefers-color-scheme: dark)');

  // Determine current theme
  const currentTheme = localStorage.getItem('theme') || 
                      (prefersDarkScheme.matches ? 'dark' : 'light');
  
  // Set initial theme
  document.documentElement.setAttribute('data-theme', currentTheme);
  updateThemeIcon(currentTheme);

  if (themeToggle) {
    themeToggle.addEventListener('click', () => {
      let theme = document.documentElement.getAttribute('data-theme');
      let newTheme = theme === 'dark' ? 'light' : 'dark';
      
      document.documentElement.setAttribute('data-theme', newTheme);
      localStorage.setItem('theme', newTheme);
      updateThemeIcon(newTheme);
    });
  }

  function updateThemeIcon(theme) {
    if(!themeToggle) return;
    // Replace content or icons based on theme
    if (theme === 'dark') {
      themeToggle.innerHTML = `<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><circle cx="12" cy="12" r="5"></circle><line x1="12" y1="1" x2="12" y2="3"></line><line x1="12" y1="21" x2="12" y2="23"></line><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line><line x1="1" y1="12" x2="3" y2="12"></line><line x1="21" y1="12" x2="23" y2="12"></line><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line></svg><span class="sr-only">Toggle Light Mode</span>`;
    } else {
      themeToggle.innerHTML = `<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path></svg><span class="sr-only">Toggle Dark Mode</span>`;
    }
  }

  // System theme changes listener
  prefersDarkScheme.addEventListener('change', (e) => {
    if(!localStorage.getItem('theme')) {
      const newTheme = e.matches ? 'dark' : 'light';
      document.documentElement.setAttribute('data-theme', newTheme);
      updateThemeIcon(newTheme);
    }
  });

  // Skeleton Loader Simulation
  const skeletonElements = document.querySelectorAll('.skeleton');
  if (skeletonElements.length > 0) {
    // Simulate data loading
    setTimeout(() => {
      skeletonElements.forEach(el => {
        el.classList.remove('skeleton');
        // If it was a placeholder div, you might reveal the actual content here
        if(el.dataset.src) el.src = el.dataset.src;
        if(el.dataset.text) el.textContent = el.dataset.text;
      });
    }, 1500); // 1.5s simulated delay
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

  // RTL Toggle Functionality
  const rtlToggle = document.querySelector('.rtl-toggle');
  
  const setRTL = (isRTL) => {
    if (isRTL) {
      document.documentElement.setAttribute('dir', 'rtl');
      localStorage.setItem('rtl', 'true');
      if (rtlToggle) rtlToggle.classList.add('active');
    } else {
      document.documentElement.setAttribute('dir', 'ltr');
      localStorage.setItem('rtl', 'false');
      if (rtlToggle) rtlToggle.classList.remove('active');
    }
  };

  // Check for saved RTL preference
  const savedRTL = localStorage.getItem('rtl') === 'true';
  setRTL(savedRTL);

  if (rtlToggle) {
    rtlToggle.addEventListener('click', () => {
      const isRTL = document.documentElement.getAttribute('dir') === 'rtl';
      setRTL(!isRTL);
    });
  }
});
