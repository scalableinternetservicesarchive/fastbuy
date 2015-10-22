require 'test_helper'

class LineItemsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
    @line_item = line_items(:one)
	@buyer = buyers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:line_items)
  end

  test "should get new" do
    get :new
    assert_response :success
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

  test "should show line_item" do
    sign_in Buyer.first
    get :show, id: @line_item
    assert_response :success
  end
  
  test "should show hash item" do
    get :show, id: @product.id
    assert_redirected_to store_path
  end

  test "should get hash cart item edit" do
    get :edit, id: @product.id
    assert_redirected_to store_path
  end
  
  test "should get edit" do
	sign_in Buyer.first
    get :edit, id: @line_item
    assert_response :success
  end

  test "should update product in hash cart" do
    cart = Hash.new
    cart[@product.id] = 1
    session[:cart] = cart
	
    patch :update, id: @product, product_id: @product.id, quantity: 2
    assert_redirected_to store_url
  end
  
  test "should update line_item" do
    sign_in Buyer.first
    patch :update, id: @line_item, product_id: @line_item.product_id, quantity: 2
    assert_redirected_to store_url
  end
  
  test "should destroy hash cart item" do
    delete :destroy, id: @product.id
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
      xhr :post, :create, product_id: @product.id, quantity: 1
    end 
    assert_response :success
    assert_select_jquery :html, '#cart' do
      assert_select 'tr#current_item td', /Product1/
    end
  end
end

