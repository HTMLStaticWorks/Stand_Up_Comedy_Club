const fs = require('fs');
const path = require('path');

const filesToProcess = [
  'index.html',
  'home-2.html',
  'shows.html',
  'booking.html',
  'comedians.html',
  'about.html',
  'gallery.html',
  'contact.html',
  '404.html',
  'coming-soon.html',
  'dashboard/admin.html',
  'dashboard/user.html'
];

filesToProcess.forEach(file => {
  const filePath = path.join(__dirname, file);
  if (!fs.existsSync(filePath)) return;

  let content = fs.readFileSync(filePath, 'utf8');
  let isDashboard = file.startsWith('dashboard');

  let logoPath = isDashboard ? '../assets/logo/logo-transparent.svg' : 'assets/logo/logo-transparent.svg';
  let faviconPath = isDashboard ? '../assets/logo/favicon-32x32.svg' : 'assets/logo/favicon-32x32.svg';

  // 1. Add Favicon if not exists
  if (!content.includes('rel="icon"')) {
    content = content.replace(
      '<!-- Stylesheets -->',
      `<link rel="icon" type="image/svg+xml" href="${faviconPath}">\n    <!-- Stylesheets -->`
    );
  }

  // 2. Replace the SVG entirely or the text inside nav-brand or cs-logo
  // Let's use Regex to find the SVG block entirely
  // It handles <svg ...>...</svg>
  content = content.replace(/<svg\s+width="\d+".*?<\/svg>/gs, `<img src="${logoPath}" alt="Comedy Hub Logo" style="width: 1.2em; height: 1.2em;">`);

  // Handle those without SVG (404, contact, gallery) 
  if (!file.includes('coming-soon') && content.match(/<a[^>]*class="nav-brand"[^>]*>The Comedy Hub<\/a>/)) {
    content = content.replace(
      /<a([^>]*)class="nav-brand"([^>]*)>The Comedy Hub<\/a>/g,
      `<a$1class="nav-brand"$2>\n                <img src="${logoPath}" alt="Comedy Hub Logo" style="width: 1.2em; height: 1.2em;">\n                The Comedy Hub\n            </a>`
    );
  }

  fs.writeFileSync(filePath, content, 'utf8');
  console.log('Updated', file);
});
