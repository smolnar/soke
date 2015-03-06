require 'spec_helper'

describe Google::Suggest do
  describe '.for' do
    it 'returns suggestion for given term' do
      downloader = double(:downloader)

      downloader.stub(:download).with('http://google.com/complete/search?q=g&client=chrome') { fixture('google/suggest.json').read }

      suggestions = Google::Suggest.for('g', downloader: downloader)

      expect(suggestions.size).to eql(20)
      expect(suggestions[0]).to eql('google')
      expect(suggestions[1]).to eql('gmail')
    end

    context 'when suggestion contain resources other than queries' do
      it 'ommits them' do
        downloader = double(:downloader)

        downloader.stub(:download).with('http://google.com/complete/search?q=google&client=chrome') { fixture('google/suggest_with_navigation.json').read }

        suggestions = Google::Suggest.for('google', downloader: downloader)

        expect(suggestions.size).to eql(18)
        expect(suggestions[0]).to eql('google maps')
        expect(suggestions[1]).to eql('google drive')
        expect(suggestions[2]).to eql('google docs')
      end
    end
  end
end
