require 'spec_helper'

describe 'Search' do
  let(:user) { create :user }

  before :each do
    login_as user
  end

  it 'shows suggestion for current query', js: true do
    visit search_path

    fill_in 'q', with: 'googl'

    within '#suggestions' do
      expect(page).to have_content('google')
      expect(page).to have_content('google maps')
    end
  end

  it 'shows results for given query', js: true do
    Bing::Search.stub(:download) { fixture('bing/google_maps.json').read }

    visit search_path

    fill_in 'q', with: 'google'

    click_link 'google maps'

    expect(page).to have_css('.result', count: 7)
    expect(page).to have_content('Google Maps')
  end
end
