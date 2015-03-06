onReady ->
  $('#q').on 'input', ->
    $.ajax
      url: '/search/suggest'
      data:
        q: $('#q').val()
      success: (suggestions) ->
        $('#suggestions').remove()

        return if !$('#q').val().length or !suggestions.length

        content = templates['suggestions'](suggestions: suggestions)

        $('#search-form').append(content)
