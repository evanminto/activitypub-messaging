module JsonLd
  class Context
    def initialize(url, expanded)
      @url = url
      @expanded = expanded
    end

    def id
      @expanded['@id']
    end

    def type_is(type)
      @expanded['@type'] && !@expanded['@type'].empty? && @expanded['@type'][0] == "#{@url}##{type}"
    end

    def method_missing(symbol)
      return super unless respond_to_missing?(symbol)

      @expanded["#{@url}##{symbol}"].map do |item|
        if item['@id'] || item['@type']
          Object.new(item)
        elsif item['@value']
          item['@value']
        end
      end
    end

    def respond_to_missing?(symbol, include_private = false)
      !@expanded["#{@url}##{symbol}"].nil? || super
    end
  end
end
