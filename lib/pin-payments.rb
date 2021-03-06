require 'faraday'

require 'pin-payments/api'
require 'pin-payments/response'

require 'pin-payments/record'
require 'pin-payments/repository'

require 'pin-payments/card'
require 'pin-payments/card_repository'
require 'pin-payments/charge'
require 'pin-payments/charge_repository'
require 'pin-payments/customer'
require 'pin-payments/customer_repository'
require 'pin-payments/refund'
require 'pin-payments/refund_repository'

module Pin
  class Error < StandardError; end
  class APIError < Error
    attr_reader :code, :error, :description, :response

    def initialize(response)
      json = response.body

      @code = response.status
      @error = json['error']
      @description = json['description']
      @response = json
    end

    def to_s
      "#@code #@error #@description"
    end
  end
end
