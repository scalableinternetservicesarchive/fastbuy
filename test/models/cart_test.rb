require 'test_helper'

class CartTest < ActiveSupport::TestCase
  setup do
    @cart = carts(:one)
    @product = products(:one)
    @line_item = line_items(:one)
  end
  
  test "add product to cart" do
    assert_difference('@cart.line_items.length', 1) do
      assert_equal Cart.add_product(@cart, {product_id: @product.id, quantity: 2}).class, LineItem
    end
    assert_difference('@cart.line_items.find_by(product_id: @product.id).quantity', +2) do
     Cart.add_product(@cart, {product_id: @product.id, quantity: 2})
    end
    assert_difference('@cart.line_items.find_by(product_id: @product.id).quantity', 0) do
      assert Cart.add_product(@cart,{product_id: @product.id, quantity: 1000}), 2
    end
  end

  test "remove product in the cart" do
    Cart.add_product(@cart, {product_id: @product.id, quantity: 2})
    assert_difference('@cart.line_items.find_by(product_id: @product.id).quantity', -1) do
     Cart.add_product(@cart, {product_id: @product.id, quantity: -1})
    end
    assert Cart.add_product(@cart, {product_id: @product.id, quantity: -1}), 1
    assert !@cart.line_items.exists?(product_id: @product.id)
  end

  test "total price in the cart" do
    total_price = products(:one).price * 2 + products(:two).price * 3
    assert_difference('@cart.line_items.length', 2) do
      Cart.add_product(@cart, {product_id: products(:one).id, quantity: 2})
      Cart.add_product(@cart, {product_id: products(:two).id, quantity: 3})
    end
    assert_equal @cart.total_price, total_price
  end
end

