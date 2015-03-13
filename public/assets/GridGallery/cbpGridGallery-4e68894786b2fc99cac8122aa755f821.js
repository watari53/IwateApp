!function(t){"use strict";function e(t,e){t.style.WebkitTransform=e,t.style.msTransform=e,t.style.transform=e}function s(){var e=n.clientWidth,s=t.innerWidth;return s>e?s:e}function i(t,e){for(var s in e)e.hasOwnProperty(s)&&(t[s]=e[s]);return t}function r(t,e){this.el=t,this.options=i({},this.options),i(this.options,e),this._init()}var n=t.document.documentElement,o={WebkitTransition:"webkitTransitionEnd",MozTransition:"transitionend",OTransition:"oTransitionEnd",msTransition:"MSTransitionEnd",transition:"transitionend"},a=o[Modernizr.prefixed("transition")],l={transitions:Modernizr.csstransitions,support3d:Modernizr.csstransforms3d};r.prototype.options={},r.prototype._init=function(){this.grid=this.el.querySelector("section.grid-wrap > ul.grid"),this.gridItems=[].slice.call(this.grid.querySelectorAll("li:not(.grid-sizer)")),this.itemsCount=this.gridItems.length,this.slideshow=this.el.querySelector("section.slideshow > ul"),this.slideshowItems=[].slice.call(this.slideshow.children),this.current=-1,this.ctrlPrev=this.el.querySelector("section.slideshow > nav > span.nav-prev"),this.ctrlNext=this.el.querySelector("section.slideshow > nav > span.nav-next"),this.ctrlClose=this.el.querySelector("section.slideshow > nav > span.nav-close"),this._initMasonry(),this._initEvents()},r.prototype._initMasonry=function(){var t=this.grid;imagesLoaded(t,function(){new Masonry(t,{itemSelector:"li.abc",columnWidth:t.querySelector(".grid-sizer")})})},r.prototype._initEvents=function(){var e=this;this.gridItems.forEach(function(t,s){t.addEventListener("click",function(){e._openSlideshow(s)})}),this.ctrlPrev.addEventListener("click",function(){e._navigate("prev")}),this.ctrlNext.addEventListener("click",function(){e._navigate("next")}),this.ctrlClose.addEventListener("click",function(){e._closeSlideshow()}),t.addEventListener("resize",function(){e._resizeHandler()}),document.addEventListener("keydown",function(t){if(e.isSlideshowVisible){var s=t.keyCode||t.which;switch(s){case 37:e._navigate("prev");break;case 39:e._navigate("next");break;case 27:e._closeSlideshow()}}}),t.addEventListener("scroll",function(){e.isSlideshowVisible?t.scrollTo(e.scrollPosition?e.scrollPosition.x:0,e.scrollPosition?e.scrollPosition.y:0):e.scrollPosition={x:t.pageXOffset||n.scrollLeft,y:t.pageYOffset||n.scrollTop}})},r.prototype._openSlideshow=function(t){if(this.isSlideshowVisible=!0,this.current=t,classie.addClass(this.el,"slideshow-open"),this._setViewportItems(),classie.addClass(this.currentItem,"current"),classie.addClass(this.currentItem,"show"),this.prevItem){classie.addClass(this.prevItem,"show");var i=Number(-1*(s()/2+this.prevItem.offsetWidth/2));e(this.prevItem,l.support3d?"translate3d("+i+"px, 0, -150px)":"translate("+i+"px)")}if(this.nextItem){classie.addClass(this.nextItem,"show");var i=Number(s()/2+this.nextItem.offsetWidth/2);e(this.nextItem,l.support3d?"translate3d("+i+"px, 0, -150px)":"translate("+i+"px)")}},r.prototype._navigate=function(t){if(!this.isAnimating){if("next"===t&&this.current===this.itemsCount-1||"prev"===t&&0===this.current)return void this._closeSlideshow();this.isAnimating=!0,this._setViewportItems();var i,r,n,o=this,h=this.currentItem.offsetWidth,c=l.support3d?"translate3d(-"+Number(s()/2+h/2)+"px, 0, -150px)":"translate(-"+Number(s()/2+h/2)+"px)",d=l.support3d?"translate3d("+Number(s()/2+h/2)+"px, 0, -150px)":"translate("+Number(s()/2+h/2)+"px)",m="";"next"===t?(i=l.support3d?"translate3d( -"+Number(2*s()/2+h/2)+"px, 0, -150px )":"translate(-"+Number(2*s()/2+h/2)+"px)",r=l.support3d?"translate3d( "+Number(2*s()/2+h/2)+"px, 0, -150px )":"translate("+Number(2*s()/2+h/2)+"px)"):(i=l.support3d?"translate3d( "+Number(2*s()/2+h/2)+"px, 0, -150px )":"translate("+Number(2*s()/2+h/2)+"px)",r=l.support3d?"translate3d( -"+Number(2*s()/2+h/2)+"px, 0, -150px )":"translate(-"+Number(2*s()/2+h/2)+"px)"),classie.removeClass(o.slideshow,"animatable"),("next"===t&&this.current<this.itemsCount-2||"prev"===t&&this.current>1)&&(n=this.slideshowItems["next"===t?this.current+2:this.current-2],e(n,r),classie.addClass(n,"show"));var u=function(){classie.addClass(o.slideshow,"animatable"),classie.removeClass(o.currentItem,"current");var s="next"===t?o.nextItem:o.prevItem;classie.addClass(s,"current"),e(o.currentItem,"next"===t?c:d),o.nextItem&&e(o.nextItem,"next"===t?m:i),o.prevItem&&e(o.prevItem,"next"===t?i:m),n&&e(n,"next"===t?d:c);var r=function(e){if(l.transitions){if(-1===e.propertyName.indexOf("transform"))return!1;this.removeEventListener(a,r)}o.prevItem&&"next"===t?classie.removeClass(o.prevItem,"show"):o.nextItem&&"prev"===t&&classie.removeClass(o.nextItem,"show"),"next"===t?(o.prevItem=o.currentItem,o.currentItem=o.nextItem,n&&(o.nextItem=n)):(o.nextItem=o.currentItem,o.currentItem=o.prevItem,n&&(o.prevItem=n)),o.current="next"===t?o.current+1:o.current-1,o.isAnimating=!1};l.transitions?o.currentItem.addEventListener(a,r):r()};setTimeout(u,25)}},r.prototype._closeSlideshow=function(){classie.removeClass(this.el,"slideshow-open"),classie.removeClass(this.slideshow,"animatable");var t=this,s=function(i){if(l.transitions){if("ul"!==i.target.tagName.toLowerCase())return;this.removeEventListener(a,s)}classie.removeClass(t.currentItem,"current"),classie.removeClass(t.currentItem,"show"),t.prevItem&&classie.removeClass(t.prevItem,"show"),t.nextItem&&classie.removeClass(t.nextItem,"show"),t.slideshowItems.forEach(function(t){e(t,"")}),t.isSlideshowVisible=!1};l.transitions?this.el.addEventListener(a,s):s()},r.prototype._setViewportItems=function(){this.currentItem=null,this.prevItem=null,this.nextItem=null,this.current>0&&(this.prevItem=this.slideshowItems[this.current-1]),this.current<this.itemsCount-1&&(this.nextItem=this.slideshowItems[this.current+1]),this.currentItem=this.slideshowItems[this.current]},r.prototype._resizeHandler=function(){function t(){e._resize(),e._resizeTimeout=null}var e=this;this._resizeTimeout&&clearTimeout(this._resizeTimeout),this._resizeTimeout=setTimeout(t,50)},r.prototype._resize=function(){if(this.isSlideshowVisible){if(this.prevItem){var t=Number(-1*(s()/2+this.prevItem.offsetWidth/2));e(this.prevItem,l.support3d?"translate3d("+t+"px, 0, -150px)":"translate("+t+"px)")}if(this.nextItem){var t=Number(s()/2+this.nextItem.offsetWidth/2);e(this.nextItem,l.support3d?"translate3d("+t+"px, 0, -150px)":"translate("+t+"px)")}}},t.CBPGridGallery=r}(window);