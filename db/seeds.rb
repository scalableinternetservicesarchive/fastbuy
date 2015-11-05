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
Cart.delete_all
if Rails.env == 'production'
  num = 4326
  usernames = (1..500).to_a
  provider = (1..20).to_a
else
  num = 50
  usernames = (1..10).to_a
  provider = (1..2).to_a
end
words = 50


string = "CoffeeScript is JavaScript done right. It provides all of JavaScript's functionality wrapped in a cleaner, more succinct syntax. In the first book on this exciting new language, CoffeeScript guru Trevor Burnham shows you how to hold onto all the power and flexibility of JavaScript while writing clearer, cleaner, and safer code. Ruby is the fastest growing and most exciting dynamic language out there. If you need to get working programs delivered fast, you should add Ruby to your toolbox. Our interactive magazine experience allows you to start reading in just a few seconds with access to any back issue at any time on the cloud. Family Library links your Amazon account to that of your spouse or partner so you can easily share apps, games, audiobooks, and books, and it now allows Prime members to share their Prime Video content. The moment you use iPhone 6s, you know you’ve never felt anything like it. With a single press, 3D Touch lets you do more than ever before. Live Photos bring your memories to life in a powerfully vivid way. And that’s just the beginning. Take a deeper look at iPhone 6s, and you’ll find innovation on every level. With 3D Touch, you can do things that were never possible before. It senses how deeply you press the display, letting you do all kinds of essential things more quickly and simply. And it gives you real-time feedback in the form of subtle taps from the all-new Taptic Engine.  You’ll experience up to 70 percent faster CPU performance, and up to 90 percent faster GPU performance for all your favorite graphics-intensive games and apps. Updated user interface - Fire OS 5 designed for quick access to your apps and content plus personalized recommendations that make it easy to discover new favorites. Up to 7 hours of reading, surfing the web, watching videos, and listening to music. Stay connected with fast web browsing, email, and calendar support. Enjoy more than 38 million movies, TV shows, songs, books, apps and games. The front-facing VGA camera is perfect for Skype calls with friends and family. Amazon engineers Fire tablets to hold up against everyday life. As measured in tumble tests, Fire is almost 2x more durable than iPad Mini 4. Plus enjoy free unlimited cloud storage for all your Amazon content and photos taken with your Fire device. Choose from millions of e-book and magazine titles. Connect with the largest online community of book lovers on Goodreads. Discover over a million titles with a Kindle Unlimited subscription. Also, listen to your favorite books with Audible. Give the gift of Fire and share endless entertainment with your friends and family. Fire has access to over 38 million movies, TV episodes, books, songs, and more, which makes it the perfect gift for everyone on your shopping list. The breakthrough price of Fire combined with Amazon’s durable engineering opens up many new ways for you to upgrade your rooms: in the kitchen as a digital cookbook or to watch your favorite cooking show, in the TV room as an entertainment controller, in the bedroom to watch a movie or check the weather before you get dressed, and in your car for backseat entertainment.".split(/\W+/)
inserts = []
start_time = Time.now
num.times do |i|
  describe=""
  words.times{ describe << string[rand(0...string.length)] +" "} 
  image_url = "/assets/images/#{i}.jpg"    
  price = rand(0..9)*100 + rand(0..9)*10 + rand(1..9) + rand(1..99)/100.0
  quantity = rand(1..100)
  rating = rand(1..4) + rand(1..9)/10.0
  inserts << "('Item#{i}', '#{describe}', '#{image_url}', #{price}, #{rating}, #{quantity}, '2015-11-04 23:56:02', '2015-11-04 23:56:02')"
  if i % 500 == 0
    sql = "INSERT INTO products (title, description, image_url, price, rating, quantity, created_at, updated_at) VALUES #{inserts.join(", ")}"
    Product.connection.execute sql
    inserts = []
  end
end
end_time = Time.now
elapse = (end_time - start_time)
puts "#{num} products in #{elapse}s!"

# Seed buyers and sellers
psswd = "12345678"
Buyer.create(email: "buyer@g.com", password: "#{psswd}")
Seller.create(email: "seller@g.com", password: "#{psswd}")

enpsswd = Buyer.new.send(:password_digest, '12345678')

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
puts "#{usernames.length * provider.length} users in #{elapse}s!"
