require 'test_helper'

class CartTest < ActiveSupport::TestCase
  setup do
    @cart = carts(:one)
    @product = products(:one)
    @line_item = line_items(:one)
  end
  
  test "cart add products test" do
    Cart.add_product(@cart, {product_id: @product.id, quantity: 1})
    assert @cart.valid?
  end

  test "cart delete items test" do
    @line_item.build_cart
    @line_item.cart.line_items.destroy_all()
    assert @line_item.cart.valid?
    assert @line_item.cart.line_items.empty?
  end
end

