require 'spec_helper'

describe 'Search' do
  it 'shows results for given query' do
    visit root_path

    fill_in 'q', with: 'google'

    find('#q').native.send_keys(:return)

    expect(page).to have_css('.result', count: 10)
    expect(page).to have_content('Google')
  end
end
