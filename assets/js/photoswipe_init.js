import PhotoSwipe from "photoswipe";
import PhotoSwipeUIDefault from "photoswipe/dist/photoswipe-ui-default";

export function photoswipe_init(gallerySelector) {
  // Init empty gallery array
  const links = document.getElementsByClassName("pic_link");
  const container = Array.prototype.map.call(links, item => {
    return {
      src: item.dataset.image,
      w: item.dataset.width,
      h: item.dataset.height
    };
  });

  Array.prototype.forEach.call(links, (link, index) => {
    link.onclick = e => {
      e.preventDefault();
      console.debug(link.getAttribute("href"));

      let shareUrl = _shareButtonData => {
        return link.getAttribute("href");
      };

      var $pswp = $(".pswp")[0],
        options = {
          bgOpacity: 0.85,
          showHideOpacity: true,
          index: index,
          loop: false,
          escKey: true,
          getPageURLForShare: function(shareButtonData) {
            return "http://polymorphic.productions" + link.getAttribute("href");
          }
        };

      // Initialize PhotoSwipe
      var gallery = new PhotoSwipe(
        $pswp,
        PhotoSwipeUIDefault,
        container,
        options
      );
      gallery.init();
    };
  });
}
