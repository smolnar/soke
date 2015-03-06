class SearchComposer
  def self.compose(query, page:, **options)
    Bing::Search.get(query, page: page)
  end
end
