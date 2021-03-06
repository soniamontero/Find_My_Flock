import Typed from 'typed.js';

function loadDynamicBannerText() {
  new Typed('#banner-typed-text', {
    strings: ["skills", "experiences", "values"],
    typeSpeed: 50,
    loop: true,
    showCursor: true,
    cursorChar: '_'
  });
}

export { loadDynamicBannerText };
