module Pin
  class Api

    attr_reader :base_uri, :js_url, :auth, :publishable_key

    def initialize(options)
      raise ArgumentError, "Pin::Api.new wants an options hash" unless Hash === options
      raise ArgumentError, "no secret key configured" unless options[:secret_key]
      raise ArgumentError, "no mode configured" unless options[:mode]

      uri = case options[:mode].to_sym
        when :live
          "https://api.pin.net.au"
        when :test
          "https://test-api.pin.net.au"
        else
          raise ArgumentError, "Incorrect API mode! Must be :live or :test"
      end

      @base_uri = "#{uri}/1"

      @js_url = "#{uri}/pin.js"

      @auth = { username: options[:secret_key], password: "" }

      @publishable_key = options[:publishable_key]
    end

    def cards
      @cards ||= CardRepository.new(self)
    end

    def charges
      @charges ||= ChargeRepository.new(self)
    end

    def customers
      @customers ||= CustomerRepository.new(self)
    end

    def refunds
      @refunds ||= RefundRepository.new(self)
    end

  end
end
