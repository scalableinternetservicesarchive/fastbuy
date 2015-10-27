FactoryGirl.define do  factory :sale_product do
    product_id 1
price "9.99"
quantity 1
expire_time "2015-10-26 11:17:58"
  end

  factory :buyer do
  email 'test@example.com'
  password 'f4k3p455w0rd'

  # if needed
  # is_active true
  end
end

