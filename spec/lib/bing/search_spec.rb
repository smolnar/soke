require 'spec_helper'

describe Bing::Search do
  describe '.get' do
    it 'searches bing for results' do
      Bing::Search.stub(:download).with('https://api.datamarket.azure.com/Bing/Search/v1/Web?Query=\'google\'&$format=json&$top=10&$skip=0') { fixture('bing/google.json').read }

      results = Bing::Search.get('google')

      expect(results.size).to eql(10)
      expect(results.first[:title]).to eql('Google')
      expect(results.first[:description]).to eql('Search the world\'s information, including webpages, images, videos and more. Google has many special features to help you find exactly what you\'re looking for.')
      expect(results.first[:url]).to eql('http://www.google.com/')
    end
  end
end
