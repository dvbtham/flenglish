$(document).ready(function() {
  var player, tag, firstScriptTag;

  tag = document.createElement('script');
  tag.src = 'https://www.youtube.com/iframe_api';
  firstScriptTag = document.getElementsByTagName('script')[0];
  firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
})

function onYouTubeIframeAPIReady() {
  player = new YT.Player('player', {
    events: {
      'onReady': onPlayerReady()
    }
  });
}

function onPlayerReady() {
  $('.sub-link').on('click', function(e) {
    e.preventDefault();
    const second = parseInt($(this).data('second'));
    if(!isNaN(second))
      player.seekTo(second, true);
  });
}
