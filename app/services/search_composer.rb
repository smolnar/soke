class SearchComposer
  def self.compose(query, user:, params:, **options)
    results = Bing::Search.get(query, page: params[:page] - 1)
    query   = Query.find_or_create_by!(value: query)

    search = Search.create!(query: query, user: user)

    if user.sessions.empty?
      search.session = Session.create!

      search.save!
    end

    results.each_with_index do |result, index|
      page = Page.find_or_initialize_by(url: result.url)

      page.title       = result.title
      page.url         = result.url
      page.description = result.description
      page.bing_uuid   = result.bing_uuid

      page.save!

      Result.create!(search: search, page: page, position: params[:page] * index)
    end

    results
  end
end
