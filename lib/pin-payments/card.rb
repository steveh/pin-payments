module Pin
	class Card < Record
    attr_accessor :number, :expiry_month, :expiry_year, :cvc, :name, :address_line1,
                  :address_line2, :address_city, :address_postcode, :address_state,
                  :address_country,
                  :token, :display_number, :scheme

    # TODO - super?
    def initialize(api, attributes = {})
      @api = api
      attributes.each {|name, value| send("#{name}=", value)}
    end

    def to_hash
      hash = {}
      instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
      hash
    end

  end
end
