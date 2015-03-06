class window.Search
  suggestions: []
  callbacks:
    suggestions: ->
      $.ajax
        url: '/search/suggest'
        data:
          q: $('#q').val()
        success: (suggestions) =>
          $('#suggestions').remove()

          return if !$('#q').val().length or !suggestions.length

          content = templates['suggestions'](suggestions: suggestions)

          $('#search-form').append(content)

          @suggestions = suggestions

          @setSuggestionsElementSize()

  constructor: ->
    @setup()

  setup: ->
    onReady =>
      $('#q').on 'input', =>
        for name, callback of @callbacks
          callback.call(@)

  setSuggestionsElementSize: ->
    $('#suggestions').width($('#q').width() + 2)

window.search = new Search()
