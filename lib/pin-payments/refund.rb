module Pin
  class Refund < Record

    attr_accessor :token,
                  :amount, :currency, :charge,
                  :success, :error_message, :created_at

  end
end
