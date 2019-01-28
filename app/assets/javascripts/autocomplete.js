$(document).on('turbolinks:load', function() {
  var app = window.app = {};

  app.Movies = function() {
    this._input = $('#term');
    this._initAutocomplete();
    $('.overlay').on('click', function() {
      window.location.href = $('a.video_url').attr('href');
    });
    if($('iframe').attr('src') === ''){
      $('iframe').remove();
    }
  };

  app.Movies.prototype = {
    _initAutocomplete: function() {
      this._input
        .autocomplete({
          source: '/movies/json',
          select: $.proxy(this._select, this)
        })
        .autocomplete('instance')._renderItem = $.proxy(this._render, this);
    },
    _render: function(ul, item) {
      var markup = [
        '<div class="title_en">' + item.title_en + '</div>',
        '<div class="title_vi">' + item.title_vi + '</div>'
      ];
      return $('<li>')
        .append(markup.join(''))
        .appendTo(ul);
    },
    _select: function(e, ui) {
      this._input.val(ui.item.title_en);
      return false;
    }
  };
})
