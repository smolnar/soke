module Google
  class Suggest
    def self.for(term, downloader: Scout::Downloader, **options)
      url     = URI.encode("http://google.com/complete/search?q=#{term}&client=chrome")
      content = downloader.download(url)
      data    = JSON.parse(content)

      data[1]
    end
  end
end
