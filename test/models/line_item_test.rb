require 'test_helper'
 
class LineItemTest < ActiveSupport::TestCase
  test "line item attributes must not be empty" do
    line_item = LineItem.new
    assert line_item.invalid?
    assert line_item.errors[:product].any?
    assert line_item.errors[:cart].any?
    assert line_item.errors[:quantity].any?
    assert line_item.errors[:price].any?
  end

  test "product must exist" do
    line_item = LineItem.new(product_id: 999,
                             cart_id: 999,
                             quantity: 1,
                             price: 1)
    assert !Product.exists?(999)
    assert !Cart.exists?(999)
    assert line_item.invalid?
    assert line_item.errors[:product].any?
    assert line_item.errors[:cart].any?

    line_item.product_id = Product.first.id
    line_item.cart_id = Cart.first.id
    assert line_item.valid?
    assert_equal line_item.product, Product.first
    assert_equal line_item.cart, Cart.first

    line_item.product = Product.second
    line_item.cart = Cart.second
    assert line_item.valid?
    assert_equal line_item.product_id, Product.second.id
    assert_equal line_item.cart_id, Cart.second.id
  end

  test "line_item price must be positive" do
    product = Product.first
    cart = Cart.first
    line_item = LineItem.new(product: product,
                             cart: cart,
                             quantity: 1)
    line_item.price = -1
    assert line_item.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      line_item.errors[:price]

    line_item.price = 0
    assert line_item.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      line_item.errors[:price]

    line_item.price = 1
    assert line_item.valid?
  end

  test "line_item quantity must be positive" do
    product = Product.first
    cart = Cart.first
    line_item = LineItem.new(product_id: product.id,
                             cart_id: cart.id,
                             price: 1)
    
    line_item.quantity = -1
    assert line_item.invalid?
    assert_equal ["must be greater than or equal to 0"],
      line_item.errors[:quantity]

    line_item.quantity = 0
    assert line_item.valid?

    line_item.quantity = 1
    assert line_item.valid?
  end

end
