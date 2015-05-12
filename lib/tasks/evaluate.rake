require 'csv'

# NOTE: Fleiss' Kappa: http://en.wikibooks.org/wiki/Algorithm_Implementation/Statistics/Fleiss%27_kappa#Ruby
#
# Computes the Fleiss' Kappa value as described in (Fleiss, 1971) 
#
def sum(arr)
  arr.inject(:+)
end

# Assert that each line has a constant number of ratings
def checkEachLineCount(matrix)
  n = sum(matrix[0])
  #  Raises an exception if lines contain different number of ratings 
  matrix.each{|line|raise "Line count != #{n} (n value)." if sum(line) !=n}
  n # The number of ratings
end

# Computes the Kappa value
# param matrix [subjects][categories]
def fleiss(matrix)
  debug = true

  #  n Number of rating per subjects (number of human raters)
  n = checkEachLineCount(matrix)   # PRE : every line count must be equal to n
  i_N = matrix.size
  k = matrix[0].size

  if debug
    puts "#{n} raters."
    puts "#{i_N} subjects."
    puts "#{k} categories."
  end

  # Computing p[]
  p = [0.0] * k
  (0...k).each do |j|
    p[j] = 0.0
    (0...i_N).each {|i| p[j] += matrix[i][j] }    
    p[j] /= i_N*n        
  end

  puts "p = #{p.join(',')}" if debug

  # Computing f_P[]    
  f_P = [0.0] * i_N

  (0...i_N).each do |i|
    f_P[i] = 0.0
    (0...k).each {|j| f_P[i] += matrix[i][j] * matrix[i][j] }    
    f_P[i] = (f_P[i] - n) / (n * (n - 1))        
  end    

  puts "f_P = #{f_P.join(',')}" if debug

  # Computing Pbar
  f_Pbar = sum(f_P) / i_N
  puts "f_Pbar = #{f_Pbar}" if debug

  # Computing f_PbarE
  f_PbarE = p.inject(0.0) { |acc,el| acc + el**2 }

  puts "f_PbarE = #{f_PbarE}" if debug 

  kappa = (f_Pbar - f_PbarE) / (1 - f_PbarE)
  puts "kappa = #{kappa}" if debug 

  kappa   
end

namespace :evaluate do
  desc 'Evaluate annotations'
  task annotations: :environment do
    tp = fp = fn = 0

    files = ENV['FILES'] ? ENV['FILES'].split(',') : Dir[Rails.root.join('tmp/annotation-study-*.csv')]

    files.each do |file|
      puts "Evaluating #{file} ..."

      _, id = *file.match(/-(\d+).*.csv/)
      user = User.find(id)
      data = CSV.read(file)
      data.each { |e| e[0] = e[0].gsub(/,\z/, '').strip }

      searches = user.searches.where.not(annotated_at: nil).order(:created_at)

      user.sessions.each do |session|
        searches = session.searches.where.not(annotated_at: nil).order(:created_at)

        next unless searches.any?

        number = data.find { |e| e[0] == searches.first.query.value }[1] rescue binding.pry

        by_annotator = data.select { |e| e[1] == number }.map { |e| e[0] }
        by_user = searches.map { |s| s.query.value }
        other = data.select { |e| by_user.include?(e[0]) && e[1] != number }

        by_annotator.each do |query|
          case
          when by_user.include?(query) then tp += 1
          when !by_user.include?(query) then fp += 1
          end
        end

        fn += other.size
      end
    end

    precision = tp / (tp + fp).to_f
    recall = tp / (tp + fn).to_f
    f = (1 + 1.5 ** 2) * precision * recall / ((1.5**2 * precision) + recall)

    puts "Precision: #{precision} (#{tp} / #{tp + fp})"
    puts "Recall: #{recall} (#{tp} / #{tp + fn})"
    puts "F: #{f}"
  end

  desc 'Evaluates Kappa coefficient'
  task kappa: :environment do
    files = ENV['FILES'].split(',')
    evaluations = []

    _, id = *files.first.match(/-(\d+).*.csv/)
    user = User.find(id)
    searches = user.searches.where.not(annotated_at: nil).order(:created_at)
    sessions = searches.map(&:session).uniq

    files.each do |file|
      queries = Array.new

      puts "Evaluating #{file} ..."

      data = CSV.read(file)
      data.each { |e| e[0] = e[0].gsub(/,\z/, '').strip }
      map = Hash.new

      searches.each_with_index.each do |search, index|
        map[data[index][1]] ||= search.session.id

        queries << map[data[index][1]]
      end

      evaluations << queries
    end

    agreements = Hash.new(0)
    values = evaluations.size.times.map { Hash.new(0) }

    (0...searches.size).each do |i|
      s = evaluations.map do |evaluation|
        session = evaluation[i]

        values[evaluations.index(evaluation)][session] += 1

        session
      end

      agreements[s.first] += 1 if s.uniq.size == 1
    end

    pr_a = agreements.values.inject(:+) / searches.size.to_f
    pr_e = sessions.map(&:id).map { |session| values.map { |value| value[session] / searches.size.to_f }.inject(:*) }.sum
    k = (pr_a - pr_e) / (1 - pr_e).to_f

    puts "Pr(a) = #{pr_a}"
    puts "Pr(e) = #{pr_e}"
    puts "K = #{k}"
  end

  desc 'Evaluate multiple annotators with Fleiss kappa coeffiecient'
  task fleiss: :environment do
    files = ENV['FILES'].split(',')
    evaluations = []

    _, id = *files.first.match(/-(\d+).*.csv/)
    user = User.find(id)
    searches = user.searches.where.not(annotated_at: nil).order(:created_at)
    sessions = searches.map(&:session).uniq.map(&:id)

    files.each do |file|
      queries = Array.new

      puts "Evaluating #{file} ..."

      data = CSV.read(file)
      data.each { |e| e[0] = e[0].gsub(/,\z/, '').strip }
      map = Hash.new

      searches.each_with_index.each do |search, index|
        map[data[index][1]] ||= search.session.id

        queries << map[data[index][1]]
      end

      evaluations << queries
    end

    matrix = Array.new

    (0...searches.size).each do |i|
      row = Array.new(sessions.size, 0)

      evaluations.each do |evaluation|
        index = sessions.index(evaluation[i])

        row[index] += 1
      end

      matrix << row
    end

    puts fleiss(matrix)
  end
end
