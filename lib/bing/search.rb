module Bing
  class Search
    attr_accessor :query, :page

    def self.get(query, page: 0, **options)
      url     = "https://api.datamarket.azure.com/Bing/Search/v1/Web?Query='#{query}'&$format=json&$top=10&$skip=#{page * 10}"
      data    = download(url)
      json    = JSON.parse(data, symbolize_names: true)
      results = Array.new

      json[:d][:results].each do |result|
        results << OpenStruct.new(title: result[:Title], description: result[:Description], url: result[:Url], bing_uuid: result[:ID])
      end

      Results.new(results)
    end

    def self.download(url)
      uri  = URI.encode(url)
      curl = Curl::Easy.new(uri)

      curl.http_auth_types = :basic
      curl.username        = ''
      curl.password        = Bing::API_KEY

      curl.perform
      curl.body_str
    end
  end
end
