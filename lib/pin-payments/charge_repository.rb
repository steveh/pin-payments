module Pin
  class ChargeRepository < Repository

    # options should be a hash with the following params
    # email, description, amount, currency, ip_address are mandatory
    # identifier must be a hash, can take the forms
    #   {card: <pinstance.cards>}
    #   {card_token: String<"...">}
    #   {customer_token: String<"...">}
    #   {customer: <pinstance.customers>}
    # eg. {email: 'user@example.com', description: 'One month subscription', amount: 19900, currency: 'USD', ip_address: '192.0.0.1', customer_token: 'asdf'}
    def create(options = {})
      options[:customer_token] = options.delete(:customer).token unless options[:customer].nil?
      super(options)
    end

  end
end
