require 'spec_helper'

describe 'Session' do
  let(:user) { create :user }

  before :each do
    login_as user
  end

  it 'creates session with query and results', js: true do
    Bing::Search.stub(:download) { fixture('bing/google_maps.json').read }

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
      create :search, session: session, query: create(:query, value: 'harry potter books'), user: user

      session = create(:session)

      create :search, session: session, query: Query.find_by(value: 'harry potter'), user: user
      create :search, session: session, query: create(:query, value: 'rowling'), user: user
      create :search, session: session, query: create(:query, value: 'harry potter movies'), user: user
    end

    it 'assigns query to current session', js: true do
      Bing::Search.stub(:download) { fixture('bing/harry_potter_7.json').read }

      visit root_path

      fill_in 'q', with: 'harry potter 7'

      wait_for_remote

      click_link 'harry potter 7 part 1'

      within '#evaluations' do
        expect(page).to have_content('Is this query related to your last one – harry potter movies?')

        click_link 'Yes'
      end

      wait_for_remote

      expect(page).not_to have_css('#evaluation-1')
      expect(page).not_to have_css('#evaluation-2')

      query = Query.find_by(value: 'harry potter 7 part 1')

      expect(query.sessions.size).to eql(1)
      expect(query.sessions.last.queries.size).to eql(4)
      expect(query.sessions.last.queries.map(&:value).sort).to eql(['harry potter', 'rowling', 'harry potter movies', 'harry potter 7 part 1'].sort)
    end

    it 'assigns query to previous session', js: true do
      Bing::Search.stub(:download) { fixture('bing/harry_potter_bookshop.json').read }

      visit root_path

      fill_in 'q', with: 'harry potter booksho'

      wait_for_remote

      click_link 'harry potter bookshop'

      within '#evaluations' do
        click_link 'No'

        expect(page).to have_content('google maps california')
        expect(page).to have_content('harry potter books')

        click_link 'harry potter books'
      end

      expect(page).not_to have_css('#evaluation-1')
      expect(page).not_to have_css('#evaluation-2')

      query = Query.find_by(value: 'harry potter bookshop')

      expect(query.sessions.size).to eql(1)
      expect(query.sessions.last.queries.size).to eql(3)
      expect(query.sessions.last.queries.map(&:value).sort).to eql(['harry potter', 'harry potter books', 'harry potter bookshop'].sort)
    end

    context 'with same query' do
      it 'does not create another search', js: true do
        Bing::Search.stub(:download) { fixture('bing/harry_potter_7.json').read }

        visit root_path

        fill_in 'q', with: 'harry potter movie'

        wait_for_remote

        click_link 'harry potter movies'

        wait_for_remote

        expect(page).not_to have_css('#evaluations')

        query = Query.find_by(value: 'harry potter movies')

        expect(query.sessions.last.searches.size).to eql(3)
      end
    end
  end
end
