window.onReady = (callback) ->
  $(document).ready(callback)
  $(document).on('page:load', callback)
