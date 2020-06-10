# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

# villager_file = File.read(Rails.root.join('db', 'seeds', 'villagers_seeds.csv'))
# # puts csv_text
# villager_list = CSV.parse(villager_file, :headers => true)

# villager_list.each do |row|
#   u = User.new
#   u.name = row['name']
#   u.emaiL_address = row['full_id']
#   u.username = row['id']
#   u.photo_url = row['photo_url']
#   u.save
# end

# puts "There are now #{User.count} rows in the users table"

USER_FILE = Rails.root.join('db','seeds','villagers_seeds.csv')

puts "Loading raw product data from #{USER_FILE}"

product_failures = []
CSV.foreach(USER_FILE, :headers => true) do |row|
  user = User.new
  user.name = row['name']
  user.username = row['full_id']
  user.photo_url = row['photo_url']
  successful = user.save

  if !successful
    product_failures << user
    puts "Failed to save user: #{user.inspect}"
  else
    puts "Created user: #{user.inspect}"
  end
end

puts "Added #{User.count} product records"
puts "#{product_failures.length} user failed to save"

# item_file = File.read(Rails.root.join('db', 'seeds', 'item_seeds.csv'))
# # puts csv_text
# item_list = CSV.parse(item_file, :headers => true, :encoding => 'ISO-8859-1')
# # puts item_list

# item_list.each do |row|
#   p = Product.new
#   p.name = row['name']
#   p.price = row['buy_value']
#   p.description = row['sources']
#   p.inventory = 10
#   p.photo_url = row['image_url']
#   p.save
# end

# puts "There are now #{Product.count} rows in the product table"

# =====
# product
# =====
# PRODUCT_FILE = Rails.root.join('db','seeds','item_seeds.csv')

# puts "Loading raw product data from #{PRODUCT_FILE}"

# product_failures = []
# CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
#   product = Product.new
#   product.name = row['name']
#   product.description = row['description']
#   product.price = row['price']
#   product.inventory = row['inventory']
#   product.photo_url = row['photo_url']
#   successful = product.save

#   if !successful
#     product_failures << product
#     puts "Failed to save product: #{product.inspect}"
#   else
#     puts "Created product: #{product.inspect}"
#   end
# end

# puts "Added #{Product.count} product records"
# puts "#{product_failures.length} products failed to save"