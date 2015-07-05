### [RayPlay: YouTube Video Player](http://rayplay.herokuapp.com)
##### by Raymond Gan

This lets you easily set up a YouTube playlist and repeatedly play either a single video or your whole playlist. You can search directly for YouTube videos by name.

Uses [Fullscreen's](http://fullscreen.com) [yt Ruby gem](https://github.com/Fullscreen/yt) and [YouTube's API v3](https://developers.google.com/youtube/v3/).

__Problem:__ Often when we play YouTube music videos, we want them to repeat automatically. YouTube doesn't normally let you do it, and sites like [ListenOnRepeat](https://listenonrepeat.com) make it more tough to build a playlist.

__Solution:__ I let you repeat play either any YouTube video or playlist, by default. You may easily build your playlist by searching directly for YouTube videos, then dragging/dropping them in the right order.

To like/dislike and upload videos, you must log in with your Google account. You must give this app [permission to access your YouTube/Google account](https://security.google.com/settings/security/permissions).

(It uses [OmniAuth2](https://github.com/zquestz/omniauth-google-oauth2) to authenticate with Google.)