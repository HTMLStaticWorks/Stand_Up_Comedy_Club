document.addEventListener('DOMContentLoaded', () => {
    // Pricing Configuration
    const PRICES = {
        ga: 25.00,
        vip: 50.00,
        student: 15.00,
        group: 80.00,
        backstage: 100.00
    };
    const FEES_PERCENTAGE = 0.10; // 10% fee
    const FIXED_FEE = 1.00;

    // DOM Elements
    const totalQtyEl = document.getElementById('total-qty');
    const subtotalEl = document.getElementById('subtotal-price');
    const totalEl = document.getElementById('total-price');
    const displayTotalEls = document.querySelectorAll('.display-total-price');
    const qtyBtns = document.querySelectorAll('.qty-btn');

    // Steps
    const steps = [
        document.getElementById('step1'),
        document.getElementById('step2'),
        document.getElementById('step3'),
        document.getElementById('step4')
    ];
    
    const indicators = [
        document.getElementById('step1-indicator'),
        document.getElementById('step2-indicator'),
        document.getElementById('step3-indicator'),
        document.getElementById('step4-indicator')
    ];

    // Form
    const detailsForm = document.getElementById('details-form');
    
    // Total Variables
    let currentTotalFormatted = '$0.00';

    // --- Quantity & Pricing Logic ---
    function updatePricing() {
        let totalQty = 0;
        let subtotal = 0;

        Object.keys(PRICES).forEach(type => {
            const input = document.getElementById('qty-' + type);
            if (input) {
                const qty = parseInt(input.value) || 0;
                totalQty += qty;
                subtotal += qty * PRICES[type];
            }
        });

        let total = 0;
        if (totalQty > 0) {
            total = subtotal + (subtotal * FEES_PERCENTAGE) + (FIXED_FEE * totalQty);
        }

        totalQtyEl.textContent = totalQty;
        subtotalEl.textContent = `$${subtotal.toFixed(2)}`;
        
        currentTotalFormatted = `$${total.toFixed(2)}`;
        totalEl.textContent = currentTotalFormatted;
        
        displayTotalEls.forEach(el => el.textContent = currentTotalFormatted);

        // Disable 'Next' if no tickets
        const btnNextTo2 = document.getElementById('btn-next-to-2');
        if(totalQty === 0) {
            btnNextTo2.disabled = true;
            btnNextTo2.classList.replace('btn-primary', 'btn-outline');
            btnNextTo2.style.opacity = '0.5';
            btnNextTo2.textContent = 'Select a Ticket';
        } else {
            btnNextTo2.disabled = false;
            btnNextTo2.classList.replace('btn-outline', 'btn-primary');
            btnNextTo2.style.opacity = '1';
            btnNextTo2.textContent = 'Continue';
        }
    }

    // Bind Quantity Buttons
    qtyBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            const action = btn.getAttribute('data-action');
            const type = btn.getAttribute('data-type');
            const input = document.getElementById('qty-' + type);
            if (!input) return;
            
            let currentVal = parseInt(input.value);
            let min = parseInt(input.getAttribute('min')) || 0;
            let max = parseInt(input.getAttribute('max')) || 10;

            if (action === 'increase' && currentVal < max) {
                input.value = currentVal + 1;
            } else if (action === 'decrease' && currentVal > min) {
                input.value = currentVal - 1;
            }
            updatePricing();
        });
    });

    // Initial Pricing Setup
    updatePricing();

    // --- Step Navigation Logic ---
    function showStep(stepIndex) {
        steps.forEach((step, idx) => {
            if (idx === stepIndex) {
                step.classList.add('active');
            } else {
                step.classList.remove('active');
            }
        });

        indicators.forEach((indicator, idx) => {
            if (idx < stepIndex) {
                indicator.classList.remove('active');
                indicator.classList.add('completed');
                indicator.innerHTML = '✓<span class="step-label">' + indicator.querySelector('.step-label').textContent + '</span>';
            } else if (idx === stepIndex) {
                indicator.classList.add('active');
                indicator.classList.remove('completed');
                // Reset text if moved back
                indicator.innerHTML = (idx + 1) + '<span class="step-label">' + indicator.querySelector('.step-label').textContent + '</span>';
            } else {
                indicator.classList.remove('active');
                indicator.classList.remove('completed');
                indicator.innerHTML = (idx + 1) + '<span class="step-label">' + indicator.querySelector('.step-label').textContent + '</span>';
            }
        });

        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    // Step 1 to Step 2
    document.getElementById('btn-next-to-2')?.addEventListener('click', () => {
        showStep(1);
    });

    // Step 2 to Step 1
    document.getElementById('btn-back-to-1')?.addEventListener('click', () => {
        showStep(0);
    });

    // Step 2 to Step 3 (via form submit validation)
    if(detailsForm) {
        detailsForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const emailInput = document.getElementById('email');
            
            // Simple email validation regex fallback
            const emailPattern = /^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$/;
            
            if (!emailPattern.test(emailInput.value)) {
                emailInput.parentElement.classList.add('has-error');
                return;
            } else {
                emailInput.parentElement.classList.remove('has-error');
                
                // Set confirmation email text
                const confirmEmailEl = document.getElementById('confirm-email');
                if(confirmEmailEl) confirmEmailEl.textContent = emailInput.value;
                
                showStep(2);
            }
        });

        // Realtime validation removal
        const emailInput = document.getElementById('email');
        if(emailInput) {
            emailInput.addEventListener('input', () => {
                emailInput.parentElement.classList.remove('has-error');
            });
        }
    }

    // Step 3 to Step 2
    document.getElementById('btn-back-to-2')?.addEventListener('click', () => {
        showStep(1);
    });

    // Step 3 to Step 4 (Simulate Payment)
    document.getElementById('btn-pay')?.addEventListener('click', (e) => {
        const btn = e.target;
        const originalText = btn.textContent;
        
        btn.textContent = 'Processing...';
        btn.disabled = true;
        
        setTimeout(() => {
            showStep(3);
        }, 2000); // 2 second simulated payment delay
    });

    // --- URL Parameters for Dynamic Booking ---
    const urlParams = new URLSearchParams(window.location.search);
    const showName = urlParams.get('show');
    const comedianName = urlParams.get('comedian');
    const showTime = urlParams.get('time');
    const showDate = urlParams.get('date');

    const showInfoEl = document.getElementById('selected-show-info');
    if (showInfoEl && showName) {
        showInfoEl.innerHTML = `<strong>${showName}</strong> feat. ${comedianName}<br>${showDate} • ${showTime}`;
    }

    // Update confirmation step if data exists
    const confirmEventEl = document.getElementById('confirm-event');
    const confirmDateEl = document.getElementById('confirm-date');

    if (confirmEventEl && showName) {
        confirmEventEl.innerHTML = `<strong>Event:</strong> ${showName}`;
    }
    if (confirmDateEl && showDate) {
        confirmDateEl.innerHTML = `<strong>Date:</strong> ${showDate}, ${showTime}`;
    }

});
