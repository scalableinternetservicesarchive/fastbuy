# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Product.delete_all
string = "CoffeeScript is JavaScript done right. It provides all of JavaScript's functionality wrapped in a cleaner, 
		more succinct syntax. In the first book on this exciting new language, CoffeeScript guru Trevor Burnham
	shows you how to hold onto all the power and flexibility of JavaScript while writing clearer, cleaner, 
	and safer code. Ruby is the fastest growing and most exciting dynamic language
        out there. If you need to get working programs delivered fast, you should add Ruby to your toolbox. 
		Our interactive magazine experience allows you to start reading in just a few seconds with access
		to any back issue at any time on the cloud. Family Library links your Amazon account to that 
		of your spouse or partner so you can easily share apps, games, audiobooks, and books, and it 
		now allows Prime members to share their Prime Video content. The moment you use iPhone 6s, you know you’ve never felt anything like it. With a single press, 3D Touch lets you do more than ever before. Live Photos bring your memories to life in a powerfully vivid way. And that’s just the beginning. Take a deeper look at iPhone 6s, and you’ll find innovation on every level. With 3D Touch, you can do things that were never possible before. It senses how deeply you press the display, letting you do all kinds of essential things more quickly and simply. And it gives you real-time feedback in the form of subtle taps from the all-new Taptic Engine.  You’ll experience up to 70 percent faster CPU performance, and up to 90 percent faster GPU performance for all your favorite graphics-intensive games and apps. ".split(/\W+/)
num = 6
words = 50
for i in 1..num
  describe=""
  words.times{ describe << string[rand(0...string.length)] +" "}
  Product.create(title: "Item#{i}",
    description: 
    %{<p>
        #{describe}
      </p>},
     image_url:   "#{i}.jpg",    
     price: rand(0..9)*100 + rand(0..9)*10 + rand(1..9) + rand(1..99)/100.0,
     quantity: rand(1..100),
     rating: rand(1..4) + rand(1..9)/10.0)
end

