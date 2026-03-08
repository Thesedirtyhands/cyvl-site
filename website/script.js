// CYVL site script

document.addEventListener('DOMContentLoaded', function () {
  const yearSpan = document.getElementById('year');
  if (yearSpan) {
    yearSpan.textContent = String(new Date().getFullYear());
  }

  const header = document.querySelector('.site-header');
  const nav = document.querySelector('.nav');
  let toggle = document.querySelector('.menu-toggle');

  if (header && nav) {
    if (!toggle) {
      toggle = document.createElement('button');
      toggle.className = 'menu-toggle';
      toggle.type = 'button';
      toggle.setAttribute('aria-expanded', 'false');
      toggle.setAttribute('aria-controls', nav.id || 'site-nav');
      toggle.textContent = 'Menu';

      const container = header.querySelector('.nav-container');
      if (container) {
        const brand = container.querySelector('.brand');
        if (brand) {
          brand.insertAdjacentElement('afterend', toggle);
        } else {
          container.insertAdjacentElement('afterbegin', toggle);
        }
      }
    }

    if (!nav.id) {
      nav.id = 'site-nav';
      toggle.setAttribute('aria-controls', nav.id);
    }

    const setMenuState = function (open) {
      header.classList.toggle('open', open);
      toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
      toggle.textContent = open ? 'Close' : 'Menu';
    };

    toggle.addEventListener('click', function () {
      const isOpen = header.classList.contains('open');
      setMenuState(!isOpen);
    });

    nav.querySelectorAll('a').forEach(function (link) {
      link.addEventListener('click', function () {
        setMenuState(false);
      });
    });
  }

  const revealItems = document.querySelectorAll('.reveal');
  if ('IntersectionObserver' in window && revealItems.length > 0) {
    const observer = new IntersectionObserver(
      function (entries, currentObserver) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            entry.target.classList.add('visible');
            currentObserver.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.15 }
    );

    revealItems.forEach(function (item) {
      observer.observe(item);
    });
  } else {
    revealItems.forEach(function (item) {
      item.classList.add('visible');
    });
  }

  const faqItems = document.querySelectorAll('.faq-item');
  faqItems.forEach(function (item) {
    item.addEventListener('toggle', function () {
      if (item.open) {
        faqItems.forEach(function (otherItem) {
          if (otherItem !== item) {
            otherItem.open = false;
          }
        });
      }
    });
  });
});
