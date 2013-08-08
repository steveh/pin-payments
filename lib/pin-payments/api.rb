module Pin
  class Api

    attr_reader :connection, :js_url, :publishable_key

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

      @js_url = "#{uri}/pin.js"

      @publishable_key = options[:publishable_key]

      @connection = Faraday.new(url: "#{uri}/1") do |faraday|
        # faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end

      @connection.basic_auth options[:secret_key], ""
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
