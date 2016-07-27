module Dynowatch
  class Analyzer
    # Return the average of an array of numbers
    def self.mean(list)
      if (list.size > 0)
        return list.inject{ |sum, el| sum + el }.to_f / list.size
      else
        return "NaN"
      end
    end

    # Return the median of an array of numbers
    def self.median(list)
      return list.sort[list.size/2] || 'NaN'
    end

    # Return the most common element in an array
    def self.mode(collection)
      collection.max_by{|elem| collection.count(elem)}
    end
  end
end
