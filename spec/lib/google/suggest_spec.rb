require 'spec_helper'

describe Google::Suggest do
  describe '.for' do
    it 'returns suggestion for given term' do
      downloader  = double(:downloader)

      downloader.stub(:download).with('http://google.com/complete/search?q=googl&client=chrome') { fixture('google/suggest.json').read }

      suggestions = Google::Suggest.for('googl', downloader: downloader)

      expect(suggestions.size).to eql(20)
      expect(suggestions[0]).to eql('google')
      expect(suggestions[1]).to eql('google maps')
    end
  end
end
