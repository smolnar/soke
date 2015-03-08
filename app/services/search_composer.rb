class SearchComposer
  def self.compose(query, user:, params:, **options)
    results = Bing::Search.get(query, page: params[:page] - 1)
    query   = Query.find_or_create_by!(value: query)

    if user.searches.any? && user.searches.last.query == query
      search = user.searches.last
    else
      search = Search.create!(query: query, user: user, session: Session.create!)
    end

    results.each_with_index do |result, index|
      page = Page.find_or_initialize_by(url: result.url)

      page.title       = result.title
      page.url         = result.url
      page.description = result.description
      page.bing_uuid   = result.bing_uuid

      page.save!

      Result.find_or_create_by!(search: search, page: page, position: index + (params[:page] - 1) * 10)
    end

    results
  end
end
