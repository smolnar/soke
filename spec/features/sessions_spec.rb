require 'spec_helper'

describe 'Sessions' do
  let(:user) { create :user }
  let(:sessions) { 2.times.map { create :session } }

  before :each do
    create :search, session: sessions[0], query: create(:query, value: 'google'), user: user
    create :search, session: sessions[0], query: create(:query, value: 'google maps'), user: user
    create :search, session: sessions[0], query: create(:query, value: 'google ventures'), user: user

    create :search, session: sessions[1], query: create(:query, value: 'gmail'), user: user
    create :search, session: sessions[1], query: create(:query, value: 'google apps'), user: user
    create :search, session: sessions[1], query: create(:query, value: 'bing'), user: user

    login_as user
  end

  it 'moves queries from one session to another one', js: true do
    visit root_path

    click_link user.email

    within "#edit_session_#{sessions[1].id}" do
      select sessions[0].name, from: "session_searches_attributes_2_session_id"
      select sessions[0].name, from: "session_searches_attributes_1_session_id"

      click_button 'Save'
    end

    queries = sessions[0].queries.reload.pluck(:value)

    expect(queries).to include('gmail')
    expect(queries).to include('google apps')
  end

  context 'when all queries are moved from session' do
    it 'removes the session' do
      visit root_path

      click_link user.email

      within "#edit_session_#{sessions[1].id}" do
        select sessions[0].name, from: "session_searches_attributes_0_session_id"
        select sessions[0].name, from: "session_searches_attributes_1_session_id"
        select sessions[0].name, from: "session_searches_attributes_2_session_id"

        click_button 'Save'
      end

      queries = sessions[0].queries.pluck(:value)

      expect(queries).to include('gmail')
      expect(queries).to include('google apps')
      expect(queries).to include('bing')

      session = Session.find_by(id: sessions[1].id)

      expect(session).to be_nil
    end
  end

  it 'moves query to a new session' do
    visit root_path

    click_link user.email

    search = sessions[1].searches[2]

    within "#edit_session_#{sessions[1].id}" do
      select 'New Session', from: "session_searches_attributes_2_session_id"

      click_button 'Save'
    end

    search.reload

    expect(search.session).not_to eql(sessions[1])
    expect(search.session.id).to be > sessions[1].id
  end
end
