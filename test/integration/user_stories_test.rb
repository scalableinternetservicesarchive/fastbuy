require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  include Warden::Test::Helpers
  Warden.test_mode!
  fixtures :products

  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:three)

    get "/"
    assert_response :success
    assert_template "store/index"

    buyer = FactoryGirl.create(:buyer)
    login_as(buyer, scope: :buyer)

    xhr :post, '/line_items', line_item: {product_id: ruby_book.id, quantity: 1}
    assert_response :success

    cart = Cart.find(buyer.cart_id)
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    get "/orders/new"
    assert_response :success
    assert_template "orders/new"

    post_via_redirect "/orders",
                      order: { name: "Sam",
                               address: "Xinyi District, Taipei",
                               email: "sam@site.tw",
                               pay_type: "Credit card" }
    assert_response :success
    assert_template "store/index"
    assert_nil cart[buyer.cart_id]

    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]

    assert_equal "Sam", order.name
    assert_equal "Xinyi District, Taipei", order.address
    assert_equal "sam@site.tw", order.email
    assert_equal "Credit card", order.pay_type

    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product

# TODO: Comment it out or not???
=begin
    mail = ActionMailer::Base.deliveries[-2]
    assert_equal ["sam@site.tw"], mail.to
    assert_equal "Hikari <fastbuy.noreply@gmail.com>", mail[:from].value
    assert_equal "Your FastBuy Order Confirmation", mail.subject

    mail = ActionMailer::Base.deliveries[-1]
    assert_equal ["sam@site.tw"], mail.to
    assert_equal "Hikari <fastbuy.noreply@gmail.com>", mail[:from].value
    assert_equal "Your FastBuy Order Shipped", mail.subject

    logout(:buyer)
=end

  end

end

