module Pin
  class Charge < Record
    attr_accessor :token,
                  :email, :description, :amount, :currency, :ip_address,
                  :card, :card_token, :customer_token,
                  :amount_refunded, :total_fees, :merchant_entitlement, :refund_pending,
                  :success, :status_message, :error_message, :transfer, :created_at

    attr_accessor :refunds

    # find all refunds for the current Charge object
    # returns a list of Refunds
    def refunds
      RefundRepository.new(api).all(token)
    end

    # creates a refund for this Charge
    # refunds the full amount of the charge by default, provide an amount in cents to override
    def refund!(amnt = nil)
      RefundRepository.new(api).create(token, amnt)
    end
  end
end
