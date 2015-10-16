require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  test "line item attributes must not be empty" do
    line_item = LineItem.new
    assert line_item.invalid?
    assert line_item.errors[:product_id].any?
    assert line_item.errors[:cart_id].any?
  end

  test "line item product id must be positive" do
    # First try valid line_item (has valid product_id)
    product = Product.new( id: 1)
    cart = Cart.new(id: 1)
    line_item = LineItem.new(product: product, cart: cart)
    line_item.product_id = product.id
    assert line_item.valid?

    # Now change product_id to an invalid value
    line_item.product_id = -1
    assert line_item.invalid?
  end

  test "line item cart id must be positive" do
    # First try valid line_item (has valid cart_id)
    product = Product.new(id: 1)
    cart = Cart.new(id: 1)
    line_item = LineItem.new(product: product, cart: cart)
    line_item.cart_id = cart.id
    assert line_item.valid?

    # Now change cart_id to an invalid value
    line_item.cart_id = -1
    assert line_item.invalid?
  end

  test "line item cart quantity must be positive" do
    # First try valid line_item (has valid cart_id)
    product = Product.new(id: 1)
    cart = Cart.new(id: 1)
    line_item = LineItem.new(product: product, cart: cart)
    line_item.cart_id = cart.id
    line_item.quantity = 1
    assert line_item.valid?

    # Now change cart_id to an invalid value
    line_item.quantity = 0
    assert line_item.invalid?
    line_item.quantity = -1
    assert line_item.invalid?
  end
end
