require 'test_helper'

class ChargesTest < Test::Unit::TestCase
  include TestHelper

  def setup
    mock_post('Cards')
    mock_api('Charges')
    mock_api('Customers')
  end

  def test_get_all # for some reason `test "get all" do` wasn't working...
    charges = pinstance.charges.all
    assert_equal 1, charges.length

    first = charges.first
    charge = pinstance.charges.find(first.token)
    assert_not_nil charge
  end

  def test_create_charge_with_card
    card = pinstance.cards.build number: '5520000000000000', expiry_month: '12', expiry_year: '2014', cvc: '123', name: 'Roland Robot', address_line1: '42 Sevenoaks St', address_city: 'Lathlain', address_postcode: '6454', address_state: 'WA', address_country: 'Australia'

    charge = pinstance.charges.create email: 'alex@payaus.com', description: '1 month of service', amount: 19900, currency: 'AUD', ip_address: '203.192.1.172',
                                card: card
    assert_not_nil charge
  end

  def test_create_charge_with_card_token
    card = pinstance.cards.create number: '5520000000000000', expiry_month: '12', expiry_year: '2014', cvc: '123', name: 'Roland Robot', address_line1: '42 Sevenoaks St', address_city: 'Lathlain', address_postcode: '6454', address_state: 'WA', address_country: 'Australia'

    charge = pinstance.charges.create email: 'alex@payaus.com', description: '1 month of service', amount: 19900, currency: 'AUD', ip_address: '203.192.1.172',
                                card_token: card.token
    assert_not_nil charge
  end

  def test_create_charge_with_already_created_card
    card = pinstance.cards.create number: '5520000000000000', expiry_month: '12', expiry_year: '2014', cvc: '123', name: 'Roland Robot', address_line1: '42 Sevenoaks St', address_city: 'Lathlain', address_postcode: '6454', address_state: 'WA', address_country: 'Australia'

    charge = pinstance.charges.create email: 'alex@payaus.com', description: '1 month of service', amount: 19900, currency: 'AUD', ip_address: '203.192.1.172',
                                card: card
    assert_not_nil charge
  end

  def test_create_charge_with_customer_token
    customer = pinstance.customers.all.first

    charge = pinstance.charges.create email: 'alex@payaus.com', description: '1 month of service', amount: 19900, currency: 'AUD', ip_address: '203.192.1.172',
                                customer_token: customer.token
    assert_not_nil charge
  end

  def test_create_charge_with_customer
    customer = pinstance.customers.all.first

    charge = pinstance.charges.create email: 'alex@payaus.com', description: '1 month of service', amount: 19900, currency: 'AUD', ip_address: '203.192.1.172',
                                customer: customer
    assert_not_nil charge
  end
end
