## pin-payments

A wrapper for the [pin.net.au](https://pin.net.au/) [API](https://pin.net.au/docs/api). MIT licensed.

## Installation

Available via [RubyGems](https://rubygems.org/gems/pin-payments). Install the usual way;

    gem install pin-payments

## Build Status

[![Build status](https://travis-ci.org/steveh/pin-payments.png)](https://travis-ci.org/steveh/pin-payments)

## Usage

### Prerequisites

You'll need to create an account at [pin.net.au](https://pin.net.au/) first.

### Setup

Create an initializer, eg. `pin.rb`, using keys from Pin's [Your Account](https://dashboard.pin.net.au/account) page.

```ruby
pinstance = Pin::Api.new secret_key: 'PIN_SECRET_KEY', publishable_key: 'PIN_PUBLISHABLE_KEY', mode: :test
```

The `mode` should be `:live` or `:test` depending on which API you want to access. The `publishable_key` is optional.

Alternatively, you could fetch keys from a YAML file, e.g. like this initializer:

```ruby
pin_config_path = Rails.root.join 'config', 'pin.yml'
if File.exists?(pin_config_path)
  configuration = YAML.load_file(pin_config_path)
  raise "No environment configured for Pin for RAILS_ENV=#{Rails.env}" unless configuration[Rails.env]
  pinstance = Pin::Api.new configuration[Rails.env].symbolize_keys
end
```

and then in `config/pin.yml`:

```yaml
test:
  secret_key: "TEST_API_SECRET"
  publishable_key: "TEST_PUBLISHABLE_KEY"
  mode: "test"

development:
  secret_key: "TEST_API_SECRET"
  publishable_key: "TEST_PUBLISHABLE_KEY"
  mode: "test"

production:
  secret_key: "LIVE_API_SECRET"
  publishable_key: "LIVE_PUBLISHABLE_KEY"
  mode: "live"
```

This allows you to inject `pin.yml` at deployment time, so that the secret key can be kept separate from your codebase.

### Usage

You'll probably want to create a form through which users can enter their details. [Pin's guide](https://pin.net.au/docs/guides/payment-forms) will step you through this. The publishable key will be necessary and, if set, can be obtained by calling `pinstance.publishable_key`. You can also ask the module for the path to the javascript for the configured mode:

```erb
<%= javascript_include_tag pinstance.js_url %>
```

Creating a charge is simple. In your controller:

```ruby
def create
  pinstance.charges.create email: 'user@example.com', description: '1 year of service', amount: 10000,
                     currency: 'AUD', ip_address: params[:ip_address], card_token: params[:card_token]

  redirect_to new_payment_path, notice: "Your credit card has been charged"
end
```

This will issue a once-off charge ([API](https://pin.net.au/docs/api/charges)).

For a recurring charge, you may wish to create a customer record at Pin. To do this, either create a `Card` object first, then a corresponding `Customer` via the [API](https://pin.net.au/docs/api/customers); or use a `card_token` returned from `pin.js` to create a customer. Note that in either case you may activate additional compliance provisions in Pin's [Terms & Conditions](https://pin.net.au/terms).

```ruby
# this doesn't contact the API
card = pinstance.cards.build number: '5520000000000000', expiry_month: '12', expiry_year: '2018', cvc: '123',
                     name: 'User Name', address_line1: 'GPO Box 1234', address_city: 'Melbourne', address_postcode: '3001', address_state: 'VIC', address_country: 'Australia'

# this contacts the API and returns a customer
customer = pinstance.customers.create 'user@example.com', card

# this contacts the API and returns a charge
pinstance.charges.create email: 'user@example.com', description: '1 year of service', amount: 10000,
                   currency: 'AUD', ip_address: '127.0.0.1', customer: customer # shorthand for customer_token: customer.token
```

You can view your customers in the [Pin dashboard](https://dashboard.pin.net.au/test/customers). This lets you charge customers regularly without asking for their credit card details each time.

```ruby
# get all customers from the API
customers = pinstance.customers.all

# find the customer you are trying to charge, assuming `current_user` is defined elsewhere
customer = customers.find {|c| c.email == current_user.email}

# create a charge for the customer
# note that using this method you will need to store the `ip_address` of the user
# generally you can store this from when you initially created the customer (via pin.js)
pinstance.charges.create email: user.email, description: '1 month of service', amount: 19900,
                   currency: 'AUD', ip_address: user.ip_address, customer: customer
```

Errors from the API will result in a`Pin::APIError` exception being thrown:

```ruby
begin
  response = pinstance.charges.create( ... )
rescue Pin::APIError => e
  redirect_to new_payment_path, flash: { error: "Charge failed: #{e.message}" }
end
```
