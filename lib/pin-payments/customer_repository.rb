module Pin
  class CustomerRepository < Repository

    # email should be a string
    # card_or_token can be a pinstance.cards object
    # or a card_token (as a string)
    def create(email, card_or_token)
      options = if card_or_token.respond_to?(:to_hash) # card
        {card: card_or_token.to_hash}
      else # token
        {card_token: card_or_token}
      end.merge(email: email)

      super(options)
    end

  end
end
