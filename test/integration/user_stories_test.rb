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
    assert_template layout: 'layouts/application'
    assert_template partial: 'carts/_cart', count: 1
    assert_template 'store/index'

    buyer = FactoryGirl.create(:buyer)
    login_as(buyer, scope: :buyer)
    buyer.create_cart
    buyer.cart_id = buyer.cart.id
    buyer.save

    xhr :post, "/line_items", line_item: { product_id: ruby_book.id, quantity: 1 }
    assert_response :success

    get "/products/#{ruby_book.id}"
    assert_response :success
    assert_template layout: 'layouts/application'
    assert_template partial: 'carts/_cart', count: 1
    assert_template 'products/show'

    xhr :post, "/line_items", line_item: { product_id: ruby_book.id, quantity: 2 }
    assert_response :success

    cart = Cart.find(buyer.cart_id)
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    get "/orders/new"
    assert_response :success
    assert_template layout: 'layouts/application'
    assert_template partial: 'carts/_cart', count: 1
    assert_template 'orders/new'
    assert_template partial: 'orders/_form', count: 1

    post_via_redirect "/orders",
                      order: { name: "Sam",
                               address: "Xinyi District, Taipei",
                               email: "sam@site.tw",
                               pay_type: "Credit card" }
    assert_response :success
    assert_template layout: 'layouts/application'
    assert_template partial: 'carts/_cart', count: 1
    assert_template 'store/index'
    assert_nil cart[buyer.cart_id]

    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]

    assert_empty order.errors.messages
    assert_equal "Sam", order.name
    assert_equal "Xinyi District, Taipei", order.address
    assert_equal "sam@site.tw", order.email
    assert_equal "Credit card", order.pay_type

    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product
    assert_equal 3, line_item.quantity

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
=end

    logout(:buyer)

  end

  test "creating a product and putting it on sale" do
    LineItem.delete_all
    Product.destroy_all

    get "/"
    assert_response :success
    assert_template layout: 'layouts/application'
    assert_template partial: 'carts/_cart', count: 1
    assert_template 'store/index'

    seller = FactoryGirl.create(:seller)
    login_as(seller, scope: :seller)

    get "/products"
    assert_response :success
    assert_template layout: 'layouts/application'
    assert_template 'products/index'

    get "/products/new"
    assert_response :success
    assert_template layout: 'layouts/application'
    assert_template 'products/new'
    assert_template partial: 'products/_form', count: 1

    post_via_redirect "/products",
                      product: { title: "Xiaomi 4",
                                 description: "A new device",
                                 image_url: "xiaomi.jpg",
                                 price: 199.99,
                                 quantity: 20
                               }
    assert_response :success
    assert_template layout: 'layouts/application'
    assert_template 'products/show'

    get "/products"
    assert_response :success
    assert_template layout: 'layouts/application'
    assert_template 'products/index'

    products = Product.all
    assert_equal 1, products.size
    product = products[0]

    assert_empty product.errors.messages
    assert_equal "Xiaomi 4", product.title
    assert_equal "A new device", product.description
    assert_equal "xiaomi.jpg", product.image_url
    assert_equal 199.99, product.price
    assert_equal 20, product.quantity

    get "/sale_products/new?sale_product%5Bproduct_id=#{product.id}"
    assert_response :success
    assert_template layout: 'layouts/application'
    assert_template 'sale_products/new'
    assert_template partial: 'sale_products/_form', count: 1

    post_via_redirect "/sale_products",
                      sale_product: { product_id: product.id,
                                      price: 199.98,
                                      quantity: 5,
                                      'started_at(1i)': "2018",
                                      'started_at(2i)': "1",
                                      'started_at(3i)': "1",
                                      'started_at(4i)': "08",
                                      'started_at(5i)': "00",
                                      'expired_at(1i)': "2018",
                                      'expired_at(2i)': "1",
                                      'expired_at(3i)': "5",
                                      'expired_at(4i)': "07",
                                      'expired_at(5i)': "45"
                                    }
    assert_response :success
    assert_template layout: 'layouts/application'
    assert_template 'sale_products/show'

    sale_products = SaleProduct.all
    assert_equal 1, sale_products.size
    sale_product = sale_products[0]

    assert_empty sale_product.errors.messages
    assert_equal product.id, sale_product.product_id
    assert_equal 199.98, sale_product.price
    assert_equal 5, sale_product.quantity
    assert_equal "UTC", sale_product.started_at.zone
    assert_equal 2018, sale_product.started_at.year
    assert_equal 1, sale_product.started_at.month
    assert_equal 1, sale_product.started_at.day
    assert_equal 1, sale_product.started_at.wday
    assert_equal 8, sale_product.started_at.hour
    assert_equal 0, sale_product.started_at.min
    assert_equal "UTC", sale_product.expired_at.zone
    assert_equal 2018, sale_product.expired_at.year
    assert_equal 1, sale_product.expired_at.month
    assert_equal 5, sale_product.expired_at.day
    assert_equal 5, sale_product.expired_at.wday
    assert_equal 7, sale_product.expired_at.hour
    assert_equal 45, sale_product.expired_at.min

    logout(:seller)

  end

end

