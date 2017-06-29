module JsonLd
  class Object
    def initialize(expanded)
      @expanded = expanded
    end

    def id
      @expanded['@id']
    end

    def activitystreams2
      Context.new('https://www.w3.org/ns/activitystreams', @expanded)
    end
  end
end
