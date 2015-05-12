namespace :dump do
  desc 'Dump'
  task trec: :environment do
    sessions = Array.new

    Session.all.each do |s|
      session = Hash.new

      session[:id] = session[:number] = s.id
      session[:start_time] = s.created_at
      session[:user_id] = s.searches.map(&:user).uniq.first.id

      session[:interactions] = []

      s.searches.order(:updated_at).each do |search|
        interaction = Hash.new

        interaction[:id] = interaction[:number] = search.id
        interaction[:query] = search.query.value
        interaction[:start_time] = search.updated_at
        interaction[:annotated_at] = search.annotated_at

        interaction[:results] = []

        search.results.order(:created_at).each do |r|
          result = Hash.new

          result[:id] = r.id
          result[:rank] = r.position
          result[:url] = r.page.url
          result[:title] = r.page.title
          result[:snippet] = r.page.description

          interaction[:results] << result
        end

        interaction[:clicks] = []

        search.results.where.not(clicked_at: nil).order(:clicked_at).each_with_index do |result, index|
          click = Hash.new

          click[:number] = index
          click[:start_time] = result.clicked_at
          click[:end_time] = search.results.where('clicked_at > ?', result.clicked_at).order(:clicked_at).first.try(:clicked_at) || s.searches.where('created_at > ?', result.clicked_at).order(:created_at).first.try(:created_at) || click[:start_time]

          click[:dwell_time] = click[:end_time] - click[:start_time]
          click[:rank] = result.position
          click[:result] = interaction[:results].find { |r| r[:id] == result.id }

          interaction[:clicks] << click
        end

        session[:interactions] << interaction
      end

      sessions << session
    end

    File.open(Rails.root.join('tmp/soke.json'), 'w:utf-8') do |f|
      f.write(JSON.pretty_generate(sessions))
    end
  end
end
