require 'test_helper'

class RefundsTest < Test::Unit::TestCase
  include TestHelper

  def setup
    mock_api('Charges')
    mock_api('Refunds', false)
  end

  def test_get_all_with_charge
    charge = pinstance.charges.first

    refunds = pinstance.refunds.all(charge)
    assert_equal 1, refunds.length
  end

  def test_get_all_with_charge_token
    charge = pinstance.charges.first

    refunds = pinstance.refunds.all(charge.token)
    assert_equal 1, refunds.length
  end

  def test_get_refunds_as_charge_method
    charge = pinstance.charges.first

    refunds = charge.refunds
    assert_equal 1, refunds.length
  end

  def test_create_refund
    charge = pinstance.charges.first

    refund = charge.refund!
    assert_not_nil refund
  end
end
