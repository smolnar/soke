require 'spec_helper'

describe 'Sign up' do
  it 'signs up user' do
    visit root_path

    click_link 'Sign up'

    fill_in 'email', with: 'alig@westside.biz'

    click_button 'Sign me up!'

    expect(page).to have_content('Password can\'t be blank')

    fill_in 'password', with: 'password123'

    click_button 'Sign me up!'

    expect(page).to have_link('alig@westside.biz')
    expect(page).to have_link('Logout')

    click_link 'Logout'
    click_link 'Sign in'

    fill_in 'email', with: 'alig@westside.biz'
    fill_in 'password', with: 'password123'

    click_button 'Sign me in!'

    expect(page).to have_link('alig@westside.biz')
  end
end
