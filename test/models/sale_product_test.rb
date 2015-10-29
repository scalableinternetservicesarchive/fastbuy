require 'test_helper'

class SaleProductTest < ActiveSupport::TestCase
  test "sale product attributes must not be empty" do
    sale_product = SaleProduct.new
    assert sale_product.invalid?
    assert sale_product.errors[:product_id].any?
    assert sale_product.errors[:started_at].any?
    assert sale_product.errors[:price].any?
    assert sale_product.errors[:expired_at].any?
    assert sale_product.errors[:quantity].any?
  end
end
