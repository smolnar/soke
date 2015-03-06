require 'spec_helper'

describe 'Search' do
  it 'shows suggestion for current query', js: true do
    visit search_path

    fill_in 'q', with: 'googl'

    expect(page).to have_content('google')
    expect(page).to have_content('google maps')
  end

  it 'shows results for given query' do
    visit search_path

    fill_in 'q', with: 'google'

    click_link 'google maps'

    expect(page).to have_css('.result', count: 10)
    expect(page).to have_content('Google')
  end
end
