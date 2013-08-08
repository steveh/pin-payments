module Pin
  class Record

    def initialize(api, attributes = {})
      @api = api

      attributes.each do |name, value|
        if name == 'card' # TODO: this should be generalised (has_one relationship i suppose)
          self.card = Card.new value
        else
          send("#{name}=", value) if respond_to? "#{name}="
        end
      end
    end

  protected

    attr_reader :api

  end
end
