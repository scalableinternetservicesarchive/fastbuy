# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Product.delete_all
Buyer.delete_all
Seller.delete_all

# Seed buyers and sellers
psswd = "12345678"
Buyer.create(email: "1@g.com", password: "#{psswd}")
Seller.create(email: "2@g.com", password: "#{psswd}")

usernames = (1..100).to_a
provider = ('a'..'a').to_a
enpsswd = Buyer.new.send(:password_digest, '12345678')

# Original
start_time = Time.now
1000.times do |i| 
  Buyer.create(email: "#{usernames[i]}"+"@#{provider[i]}.com", password: "#{psswd}")
end
end_time = Time.now
elapse = (end_time - start_time)
puts "Original: #{elapse}"
=begin
Buyer.delete_all
# Use Transaction
start_time = Time.now
ActiveRecord::Base.transaction do
  Buyer.create(email: "#{usernames[i]}"+"@#{provider[i]}.com", password: "#{psswd}")
end
end_time = Time.now
elapse = (end_time - start_time)
puts "Transcation: #{elapse}"

Buyer.delete_all
# Use No Validation
start_time = Time.now
1000.times do |i| 
  buyer = Buyer.new(email: "#{usernames[i]}"+"@#{provider[i]}.com", password: "#{psswd}")
  buyer.save(validate: false)
end
end_time = Time.now
elapse = (end_time - start_time)
puts "No-validation: #{elapse}"

Buyer.delete_all
# Use No Validation and Transaction
start_time = Time.now
ActiveRecord::Base.transaction do
  1000.times do |i| 
    buyer = Buyer.new(email: "#{usernames[i]}"+"@#{provider[i]}.com", password: "#{psswd}")
    buyer.save(validate: false)
  end
end
end_time = Time.now
elapse = (end_time - start_time)
puts "No-validation and Transaction: #{elapse}"

Buyer.delete_all
# Use Encrypted Password
start_time = time.now
1000.times do |i| 
  Buyer.create(email: "#{usernames[i]}"+"@#{provider[i]}.com", encrypted_password: "#{enpsswd}")
end
end_time = time.now
elapse = (end_time - start_time)
puts "Encrypted: #{elapse}"


Buyer.delete_all
# Use Encrypted Password and Transaction
start_time = time.now
ActiveRecord::Base.transaction do
  1000.times do |i| 
    Buyer.create(email: "#{usernames[i]}"+"@#{provider[i]}.com", encrypted_password: "#{enpsswd}")
  end
end
end_time = time.now
elapse = (end_time - start_time)
puts "Encrypted and Transaction: #{elapse}"

Buyer.delete_all
# Use Encrypted Password and No-Validation
start_time = time.now
  1000.times do |i| 
    buyer = Buyer.new(email: "#{usernames[i]}"+"@#{provider[i]}.com", encrypted_password: "#{enpsswd}")
    buyer.save(validation: false)
  end
end_time = time.now
elapse = (end_time - start_time)
puts "Encrypted and No-validation: #{elapse}"

Buyer.delete_all
# Use Encrypted Password and No-Validation and Transaction
start_time = time.now
ActiveRecord::Base.transaction do
  1000.times do |i| 
    buyer = Buyer.new(email: "#{usernames[i]}"+"@#{provider[i]}.com", encrypted_password: "#{enpsswd}")
    buyer.save(validation: false)
  end
end
end_time = time.now
elapse = (end_time - start_time)
puts "Encrypted and No-validation and Transaction: #{elapse}"
=end
