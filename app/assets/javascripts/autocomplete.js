$(document).on('turbolinks:load', function() {
  var app = window.app = {};

  app.Movies = function() {
    this._input = $('input[data-behavior="autocomplete"]');
    if (this._input.length > 0)
      this._initAutocomplete(this._input.data('source'));
    $('.overlay').on('click', function() {
      window.location.href = $('a.video_url').attr('href');
    });
    if($('iframe').attr('src') === ''){
      $('iframe').remove();
    }
  };

  app.Movies.prototype = {
    _initAutocomplete: function(sourceUrl) {
      this._input
        .autocomplete({
          source: function(request, response) {
            $.get(sourceUrl, {q: {title_cont: request.term}}, function(data) {
                response(data);
            });
          },
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
