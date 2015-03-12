module Google
  class Suggest
    def self.for(term, downloader: Scout::Downloader, **options)
      # TODO use output=toolbar or client=firefox to resolve unicode characters

      url     = "http://google.com/complete/search?q=#{term}&client=chrome"
      content = downloader.download(url)
      data    = JSON.parse(content)
      types   = data[4]['google:suggesttype']

      data[1].each_with_index.map { |suggestion, index|
        next unless types[index] == 'QUERY'

        suggestion.encode('utf-8', 'windows-1250', invalid: :replace, undef: :replace, replace: '?')
      }.compact
    end
  end
end
