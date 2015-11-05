# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Buyer.delete_all
Seller.delete_all
Cart.delete_all
# Seed buyers and sellers
psswd = "12345678"
Buyer.create(email: "buyer@g.com", password: "#{psswd}")
Seller.create(email: "seller@g.com", password: "#{psswd}")

usernames = (1..500).to_a
provider = (1..20).to_a
enpsswd = Buyer.new.send(:password_digest, '12345678')

=begin
# Original
start_time = Time.now
provider.length.times do |j|
  usernames.length.times do |i| 
    Buyer.create!(email: "#{usernames[i]}@#{provider[j]}.com", password: "#{psswd}")
  end
end
end_time = Time.now
elapse = (end_time - start_time)
puts "Original: #{elapse}"

# Buyer.delete_all
# Use Transaction
start_time = Time.now
ActiveRecord::Base.transaction do
  provider.length.times do |j|
    usernames.length.times do |i| 
      Buyer.create!(email: "#{usernames[i]}@#{provider[j]}.com", password: "#{psswd}")
    end
  end
end
end_time = Time.now
elapse = (end_time - start_time)
puts "Transcation: #{elapse}"

# Buyer.delete_all
# Use No Validation
start_time = Time.now
provider.length.times do |j|
  usernames.length.times do |i| 
    buyer = Buyer.new(email: "#{usernames[i]}@#{provider[j]}.com", password: "#{psswd}")
    buyer.save!(validate: false)
  end
end
end_time = Time.now
elapse = (end_time - start_time)
puts "No-validation: #{elapse}"

# Buyer.delete_all
# Use No Validation and Transaction
start_time = Time.now
ActiveRecord::Base.transaction do
  provider.length.times do |j|
    usernames.length.times do |i| 
      buyer = Buyer.new(email: "#{usernames[i]}@#{provider[j]}.com", password: "#{psswd}")
      buyer.save!(validate: false)
    end
  end
end
end_time = Time.now
elapse = (end_time - start_time)
puts "No-validation and Transaction: #{elapse}"
=end

=begin
# Buyer.delete_all
# Use Encrypted Password
start_time = Time.now
provider.length.times do |j|
  usernames.length.times do |i| 
    Buyer.create!(email: "#{usernames[i]}@#{provider[j]}.com", encrypted_password: "#{enpsswd}", password: "#{psswd}")
  end
end
end_time = Time.now
elapse = (end_time - start_time)
puts "Encrypted: #{elapse}"

# Buyer.delete_all
# Use Encrypted Password and Transaction
start_time = Time.now
ActiveRecord::Base.transaction do
  provider.length.times do |j|
    usernames.length.times do |i| 
      Buyer.create!(email: "#{usernames[i]}@#{provider[j]}.com", encrypted_password: "#{enpsswd}", password: "#{psswd}")
    end
  end
end
end_time = Time.now
elapse = (end_time - start_time)
puts "Encrypted and Transaction: #{elapse}"
# Buyer.delete_all
# Use Encrypted Password and No-Validation
start_time = Time.now
provider.length.times do |j|
  usernames.length.times do |i| 
    buyer = Buyer.new(email: "#{usernames[i]}@#{provider[j]}.com", encrypted_password: "#{enpsswd}", password: "#{psswd}")
    buyer.save!(validation: false)
  end
end
end_time = Time.now
elapse = (end_time - start_time)
puts "Encrypted and No-validation: #{elapse}"

# Buyer.delete_all
# Use Encrypted Password and No-Validation and Transaction
start_time = Time.now
ActiveRecord::Base.transaction do
  provider.length.times do |j|
    usernames.length.times do |i| 
      buyer = Buyer.new(email: "#{usernames[i]}@#{provider[j]}.com", encrypted_password: "#{enpsswd}", password: "#{psswd}")
      buyer.save!(validation: false)
    end
  end
end
end_time = Time.now
elapse = (end_time - start_time)
puts "Encrypted and No-validation and Transaction: #{elapse}"
=end
start_time = Time.now
provider.length.times do |j|
  inserts = []
  usernames.length.times do |i| 
    inserts << "('#{usernames[i]}@#{provider[j]}.com', '#{enpsswd}', '2015-11-04 23:56:02', '2015-11-04 23:56:02')"
  end
  sql = "INSERT INTO buyers (email, encrypted_password, created_at, updated_at) VALUES #{inserts.join(", ")}"
  Buyer.connection.execute sql
end 
end_time = Time.now
elapse = (end_time - start_time)
puts "SQL: #{elapse}"
