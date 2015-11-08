require 'test_helper'

class LineItemsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
    @line_item = line_items(:one)
    @buyer = buyers(:one)
  end

  test "should create product in hash cart" do
    post :create, product_id: @product.id, quantity: 1
    assert_redirected_to store_path
  end
  
  test "should create line_item" do
    sign_in Buyer.first
    assert_difference('LineItem.count') do
      post :create, product_id: @product.id, quantity: 1
    end
    assert_redirected_to store_path
  end

 
  test "should destroy hash cart item" do
    delete :destroy, id: @product.id, product_id: @product_id
    cart = session[:cart]
    assert_nil cart[products(:one).id.to_s]
    assert_redirected_to store_url
  end
  
  
  test "should destroy line_item" do
    sign_in Buyer.first
    assert_difference('LineItem.count', -1) do
      delete :destroy, id: @line_item
    end
    assert_redirected_to store_url
  end

  test "should create line_item via ajax" do
    sign_in Buyer.first
    assert_difference('LineItem.count') do
      xhr :post, :create, product_id: @line_item.product_id, quantity: 1
    end 
    assert_response :success
    assert_select_jquery :html, '#cart' do
      assert_select 'tr#current_item td', /Product1/
    end
  end
end
