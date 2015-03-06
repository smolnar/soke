module Google
  class Suggest
    def self.for(term, downloader: Scout::Downloader, **options)
      url     = "http://google.com/complete/search?q=#{term}&client=chrome"
      content = downloader.download(url)
      data    = JSON.parse(content)

      data[1].map { |suggestion| suggestion.encode('UTF-8', 'WINDOWS-1250', invalid: :replace, undef: :replace, replace: '?') }
    end
  end
end
