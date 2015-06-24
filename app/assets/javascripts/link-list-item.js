(function () {
  'use strict';

  moj.Modules.LinkListItem = {
    el: '.link-list-item',

    init: function() {
      this.cacheEls();
      this.bindEvents();
    },

    cacheEls: function() {
      this.$items = $(this.el);
    },

    bindEvents: function() {
      this.$items.each(function() {
        var self = this;
        $(self).closest('li').addClass('linked-list-item').on('click', function(e) {
          document.location = $(self).attr('href');
        });
      });
    }
  };
}());
