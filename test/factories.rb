FactoryGirl.define do  factory :seller do
    
  end

  factory :buyer do
  email 'test@example.com'
  password 'f4k3p455w0rd'

  # if needed
  # is_active true
  end
end

