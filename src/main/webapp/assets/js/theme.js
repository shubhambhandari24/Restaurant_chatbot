// ============================================================
//  theme.js — shared Dark/Light toggle, persisted via localStorage
//  Include this script on every page BEFORE </body>
// ============================================================

(function () {
  // Apply saved theme immediately (before paint) to avoid flash
  const saved = localStorage.getItem('ss_theme') || 'dark';
  document.documentElement.setAttribute('data-theme', saved);
})();

function initThemeToggle() {
  const btn = document.getElementById('themeToggle');
  if (!btn) return;

  // Sync icon state on load
  _syncIcons();

  btn.addEventListener('click', () => {
    const current = document.documentElement.getAttribute('data-theme');
    const next = current === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', next);
    localStorage.setItem('ss_theme', next);
    _syncIcons();
  });

  function _syncIcons() {
    const theme = document.documentElement.getAttribute('data-theme');
    const sunEl  = btn.querySelector('.icon.sun');
    const moonEl = btn.querySelector('.icon.moon');
    if (sunEl && moonEl) {
      sunEl.style.transform  = theme === 'dark' ? 'rotate(-30deg)' : 'rotate(0deg)';
      moonEl.style.transform = theme === 'dark' ? 'rotate(0deg)'  : 'rotate(30deg)';
    }
  }
}

document.addEventListener('DOMContentLoaded', initThemeToggle);
