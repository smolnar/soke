module Bing
  class Results
    include Enumerable

    def initialize(results)
      @results = results
    end

    def each(&block)
      @results.each(&block)
    end

    alias :size :count
  end
end
