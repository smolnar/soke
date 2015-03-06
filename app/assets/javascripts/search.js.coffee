onReady ->
  $('#q').on 'input', ->
    $.ajax
      url: '/search/suggest'
      data:
        q: $('#q').val()
      success: (data) ->
        $('#suggestions').replaceWith(data)
