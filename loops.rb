string = "CoffeeScript is JavaScript done right. It provides all of JavaScript's functionality wrapped in a cleaner, 
		more succinct syntax. In the first book on this exciting new language, CoffeeScript guru Trevor Burnham
	shows you how to hold onto all the power and flexibility of JavaScript while writing clearer, cleaner, 
	and safer code. Ruby is the fastest growing and most exciting dynamic language
        out there. If you need to get working programs delivered fast, you should add Ruby to your toolbox. 
		Our interactive magazine experience allows you to start reading in just a few seconds with access
		to any back issue at any time on the cloud. Family Library links your Amazon account to that 
		of your spouse or partner so you can easily share apps, games, audiobooks, and books, and it 
		now allows Prime members to share their Prime Video content.".split(/\W+/)
describe=""
10.times{describe << string[rand(0...string.length)] + " "}
puts %{<p>
 #{describe}
</p>}
