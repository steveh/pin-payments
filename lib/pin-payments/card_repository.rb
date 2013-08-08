module Pin
  class CardRepository < Repository

    # options should be a hash with the following keys:
    # :number, :expiry_month, :expiry_year, :cvc, :name, :address_line1,
    # :address_city, :address_postcode, :address_state, :address_country
    #
    # it can also have the following optional keys:
    # :address_line2
    def create(options = {})
      super(options)
    end

  end
end
