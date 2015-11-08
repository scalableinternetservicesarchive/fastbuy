require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
    assert product.errors[:quantity].any?
    assert product.errors[:seller].any?
  end

  test "product seller must exist" do
    product = Product.new(title:       "My Book Title",
                          description: "yyy",
                          price: 1,
                          image_url:   "zzz.jpg",
                          quantity:     1,
                          seller_id: 999)
    assert !Seller.exists?(999)
    assert product.invalid?
    assert product.errors[:seller].any?
 
    product.seller_id = sellers(:one).id
    assert product.valid?
    assert_equal product.seller, sellers(:one)
   
    product.seller = sellers(:two)
    assert product.valid?
    assert_equal product.seller_id, sellers(:two).id
  end

  test "product price must be positive" do
    seller = sellers(:one)
    product = Product.new(title:       "My Book Title",
                          description: "yyy",
                          image_url:   "zzz.jpg",
                          quantity:     1,
                          seller: seller)
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], 
      product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  test "product quantity must be positive" do
    seller = sellers(:one)
    product = Product.new(title:       "My Book Title",
                          description: "yyy",
                          image_url:   "zzz.jpg",
                          price:     1,
                          seller_id: seller.id)
    product.quantity = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0"],
      product.errors[:quantity]

    product.quantity = 0
    assert product.valid?

    product.quantity = 1
    assert product.valid?
  end

  test "product rating must be positive" do
    seller = sellers(:one)
    product = Product.new(title:       "My Book Title",
                          description: "yyy",
                          image_url:   "zzz.jpg",
                          quantity:     1,
                          price:     1,
                          seller: seller)
    product.rating = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.0"],
      product.errors[:rating]

    product.rating = 5.1
    assert product.invalid?
    assert_equal ["must be less than or equal to 5.0"], 
      product.errors[:rating]

    product.rating = 1
    assert product.valid?
  end

  def new_product(image_url)
    seller = sellers(:one)
    Product.new(title:       "My Book Title",
                description: "yyy",
                price:       1,
                image_url:   image_url,
                quantity:    1,
                seller:  seller)
  end

  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
             http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    
    ok.each do |name|
      assert new_product(name).valid?, "#{name} should be valid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

end
