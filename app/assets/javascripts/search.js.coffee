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
    @setupEvaluation()

  setup: ->
    onReady =>
      $('#q').autocomplete
        minLength: 0
        source: =>
          for name, callback of @callbacks
            callback.call(@)

  setSuggestionsElementSize: ->
    $('#suggestions').width($('#q').width() + 2)

  setupEvaluation: ->
    onReady ->
      $('#evaluation-1 .no').click -> $('#evaluation-2').removeClass('hidden')
      $('#evaluation-1 a').click -> $('#evaluation-1').hide()
      $('#evaluation-2 a').click -> $('#evaluation-2').hide()

window.search = new Search()
