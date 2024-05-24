require "./index"


# eaxmple
data = Quotes.new
quote = data.limit("indonesia", 2)
quote.each do |item|
  puts "Quotes: #{item['quote']}"
  puts "Author: #{item['author']}"
  puts "------------------------------\n\n"
end

quote = data.search("indonesia")
quote.each do |item|
  puts "Quotes: #{item['quote']}"
  puts "Author: #{item['author']}"
  puts "------------------------------"
end
puts "succes get #{quote.length} quote"
