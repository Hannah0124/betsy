require 'csv'
require 'faker'
require 'date'

# ruby db/review_seeds.rb

CSV.open("db/seeds/review_seeds.csv", "w", :write_headers => true, :headers => ["rating","description","reviewer","product_id", "created_at"]) do |row|
  300.times do 
    rating = rand(1..5)
    description = Faker::Quote.famous_last_words
    reviewer = Faker::Name.name
    product_id = rand(1..300)
    created_at = Faker::Time.between(from: Date.today - 120, to: Date.today) 

    row << [rating, description, reviewer,product_id, created_at]
  end
end 
