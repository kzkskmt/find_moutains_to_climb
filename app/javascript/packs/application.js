require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")
require("youtube.js")
require("google_maps.js")
require("openweather_map.js")

window.addEventListener('DOMContentLoaded', event => {

  // navbar縮小の定義
  var navbarShrink = function () {
      const navbarCollapsible = document.body.querySelector('#mainNav');
      if (!navbarCollapsible) {
          return;
      }
      // トップページ、スクロール0の時のみnavberが透過
      if ( window.document.body.id === 'page-top' && window.scrollY === 0) {
          navbarCollapsible.classList.remove('navbar-shrink')
      } else {
          navbarCollapsible.classList.add('navbar-shrink')
      }
  };

  // navbarの縮小
  navbarShrink();

  // ページがスクロールされるとnavbarを縮小する
  document.addEventListener('scroll', navbarShrink);

  // メディアのwidthに応じてnavbarの表示を変更する
  const navbarToggler = document.body.querySelector('.navbar-toggler');
  const responsiveNavItems = [].slice.call(
      document.querySelectorAll('#navbarResponsive .nav-link')
  );
  responsiveNavItems.map(function (responsiveNavItem) {
      responsiveNavItem.addEventListener('click', () => {
          if (window.getComputedStyle(navbarToggler).display !== 'none') {
              navbarToggler.click();
          }
      });
  });
});

// フラッシュメッセージのフェードアウト
$(function(){
  setTimeout("$('#flash').fadeOut('slow')", 2000);
});