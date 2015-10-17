require 'test_helper'

class CartTest < ActiveSupport::TestCase
  test "cart add products test" do
    product = Product.new(id: 1)
    cart = Cart.new(id: 1)
    line_item = LineItem.new(product: product, cart: cart)
    line_item.product_id = product.id
    assert line_item.valid?
    cart.add_product(product.id)
    assert cart.valid?
  end

  test "cart delete items test" do
    line_item = LineItem.new
    line_item.product = products(:one)
    line_item.build_cart

    line_item.cart.line_items.destroy_all()
    assert line_item.cart.valid?
    assert line_item.cart.line_items.empty?
  end
end
