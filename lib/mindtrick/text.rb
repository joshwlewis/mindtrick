module Mindtrick
  class Text < String
    def each_fragment
      return to_enum(:each_fragment) unless block_given?
      (0..term.length).each do |i|
        yield term[0...i]
      end
    end

    def term
      strip.gsub(/\s+/,' ')
    end

    def prefixed(prefix)
      "#{ prefix }:#{ downcase }"
    end

  end
end
