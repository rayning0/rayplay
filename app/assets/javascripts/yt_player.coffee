$ ->

  $("a[data-remote]").on "ajax:success", (e, data, status, xhr) ->
    if data.error
      flash_html = "<span class='flash'><div class='alert alert-danger'>" + data.error[0][1] + "</div></span>"
      $('.flash').replaceWith(flash_html)
    else
      $(".likes[data-id=#{data.uid}]").text data.likes
      $(".dislikes[data-id=#{data.uid}]").text data.dislikes
    return

  $('.yt_preview').click -> makeVideoPlayer $(this).data('uid')

  # Initially the player isn't loaded
  window.ytPlayerLoaded = false

  _run = ->
    # Runs as soon as Google API is loaded
    $('.yt_preview').first().click()
    return

  $(window).bindWithDelay('resize', ->
    player = $('#ytPlayer')
    player.height(player.width() / 1.777777777) if player.size() > 0
    return
  , 500)

  makeVideoPlayer = (vid) ->
    if !window.ytPlayerLoaded
      player_wrapper = $('#player-wrapper')
      player_wrapper.append('<div id="ytPlayer"><p>Loading player...</p></div>')

      window.ytplayer = new YT.Player('ytPlayer', {
        width: '100%'
        height: player_wrapper.width() / 1.777777777
        videoId: vid
        playerVars: {
          wmode: 'opaque'
          autoplay: 1
          modestbranding: 1
        }
        events: {
          'onReady': -> window.ytPlayerLoaded = true
          'onError': (errorCode) -> alert("Sorry, but this error occurred: " + errorCode)
          # Automatically replays video when done
          'onStateChange': (event) ->
            if event.data == YT.PlayerState.ENDED
              window.ytplayer.playVideo()
        }
      })
    else
      window.ytplayer.loadVideoById(vid)
      #window.ytplayer.pauseVideo()
    return
  return

  google.setOnLoadCallback _run
  return