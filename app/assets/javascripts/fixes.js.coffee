# Progressbar
Turbolinks.enableProgressBar()

# Shorthand for HandlebarsTemplates
window.templates = HandlebarsTemplates

# Hide suggestions when clicking outside of suggestions list
window.onresize = ->
  search.setSuggestionsElementSize()
