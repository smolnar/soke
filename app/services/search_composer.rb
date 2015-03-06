class SearchComposer
  def self.compose(query, page:, **options)
    Bing::Search.get(query, page: page - 1)
  end
end
