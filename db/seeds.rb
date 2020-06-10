# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'csv'


# =====
# category
# =====

CATEGORY_FILE = Rails.root.join('db', 'categories-seeds.csv')
puts "Loading raw vote data from #{CATEGORY_FILE}"

category_failures = []
CSV.foreach(CATEGORY_FILE, :headers => true) do |row|
  category = Category.new
  category.name = row['name']
  successful = category.save
  if !successful
    category_failures << category
    puts "Failed to save category: #{category.inspect}"
  else
    puts "Created category: #{category.inspect}"
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} categorys failed to save"



# =====
# product
# =====
PRODUCT_FILE = Rails.root.join('db', 'products-seeds.csv')

puts "Loading raw product data from #{PRODUCT_FILE}"

product_failures = []
CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  product = Product.new
  product.name = row['name']
  product.description = row['description']
  product.price = row['price']
  product.inventory = row['inventory']
  product.photo_url = row['photo_url']
  product.active = row['active']
  successful = product.save

  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
  else
    puts "Created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"



# =====
# categories_products (join table)
# =====

products = Product.all
categories = Category.all
# CATEGORIES = ["Accessories", "Tops", "Dresses", "Furniture", "Tops", "Bottoms", "Furniture", "Furniture"]

i = 0
products.each do |product|
  random_idx = rand(0...categories.length)
  product.categories << categories[random_idx]
  # product.categories << CATEGORIES[i]
  i += 1
end

# Since we set the primary key (the ID) manually on each of the
# tables, we've got to tell postgres to reload the latest ID
# values. Otherwise when we create a new record it will try
# to start at ID 1, which will be a conflict.
puts "Manually resetting PK sequence on each table"
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

puts "done"
