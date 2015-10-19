require 'test_helper'
 
class LineItemTest < ActiveSupport::TestCase
   test "line item attributes must not be empty" do
     product = Product.new(id: 1)
     product.quantity = 1
     line_item = LineItem.new(product: product)
     # but we do have a product associated with this line_item
     assert line_item.errors[:product_id].none?
   end
 
   test "line item cart quantity must be positive" do
     # First try valid line_item (has valid cart_id)
     product = Product.new(id: 1)
     product.quantity = 1
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
