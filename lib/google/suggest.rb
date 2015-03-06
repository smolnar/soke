module Google
  class Suggest
    def self.for(term, downloader: Scout::Downloader, **options)
      url     = "http://google.com/complete/search?q=#{term}&client=chrome"
      content = downloader.download(url)
      data    = JSON.parse(content)
      types   = data[4]['google:suggesttype']

      data[1].each_with_index.map { |suggestion, index|
        next unless types[index] == 'QUERY'

        suggestion.encode('UTF-8', 'WINDOWS-1252', invalid: :replace, undef: :replace, replace: '?')
      }.compact
    end
  end
end
