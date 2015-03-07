require 'spec_helper'

describe 'Session' do
  let(:user) { create :user }

  before :each do
    login_as user
  end

  it 'creates session with query and results', js: true do
    Bing::Search.stub(:download) { fixture('bing/google-maps.json').read }

    visit search_path

    fill_in 'q', with: 'google'

    wait_for_remote

    click_link 'google maps'

    wait_for_remote

    query   = Query.find_by(value: 'google maps')
    search  = query.searches.last
    session = query.sessions.last

    expect(session.queries.size).to eql(1)
    expect(search.user).to eql(user)

    results = query.results

    expect(results.pluck(:position).sort).to eql((0..6).to_a)

    result = results.first
    page   = result.page

    expect(result.position).to eql(0)
    expect(result.clicked_at).to be_nil

    expect(page.title).to eql('Google Maps')
    expect(page.url).to eql('https://maps.google.com/')
  end

  context 'with existing sessions' do
    before :each do
      session = create(:session)

      create :search, session: session, query: create(:query, value: 'google maps'), user: user
      create :search, session: session, query: create(:query, value: 'google maps california'), user: user

      session = create(:session)

      create :search, session: session, query: create(:query, value: 'harry potter'), user: user
      create :search, session: session, query: create(:query, value: 'bookshop harry potter'), user: user

      session = create(:session)

      create :search, session: session, query: Query.find_by(value: 'harry potter'), user: user
      create :search, session: session, query: create(:query, value: 'rowling'), user: user
      create :search, session: session, query: create(:query, value: 'harry potter books'), user: user
    end

    it 'assigns query to current session', js: true do
      Bing::Search.stub(:download) { fixture('bing/bookshop.json').read }

      visit root_path

      fill_in 'q', with: 'bookshop harry pott'

      wait_for_remote

      click_link 'bookshop harry potter'

      within '#evaluations' do
        expect(page).to have_content('Is this query related to your last one – harry potter books?')

        click_link 'Yes'
      end

      wait_for_remote

      expect(page).not_to have_content('Is this query related to your last one – harry potter books?')

      query = Query.find_by(value: 'bookshop harry potter')

      expect(query.sessions.size).to eql(2)
      expect(query.sessions.last.queries.size).to eql(4)
      expect(query.sessions.last.queries.map(&:value)).to eql(['harry potter', 'rowling', 'harry potter books', 'bookshop harry potter'])
    end

    it 'assigns query to previous session', js: true do
    end
  end
end
