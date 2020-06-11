require 'csv'

USER_FILE = Rails.root.join('db','seeds','villagers_seeds.csv')

puts "Loading raw product data from #{USER_FILE}"

user_failures = []
CSV.foreach(USER_FILE, :headers => true) do |row|
  user = User.new
  user.name = row['name']
  user.username = row['full_id']
  user.email_address = row['full_id']
  user.photo_url = row['photo_url']
  user.uid = row['row_n']
  successful = user.save

  if !successful
    user_failures << user
    puts "Failed to save user: #{user.inspect}"
  else
    puts "Created user: #{user.inspect}"
  end
end

puts "Added #{User.count} user records"
puts "#{user_failures.length} user failed to save"


# =====
# category
# =====

CATEGORY_FILE = Rails.root.join('db', 'seeds', 'categories-seeds.csv')
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
PRODUCT_FILE = Rails.root.join('db', 'seeds', 'item_seeds.csv')
# PRODUCT_FILE = Rails.root.join('db', 'seeds', 'products-seeds.csv')

puts "Loading raw product data from #{PRODUCT_FILE}"

product_failures = []
CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  product = Product.new
  product.name = row['name']
  product.description = row['id_full']
  product.price = row['sell_value']
  product.inventory = 10
  product.photo_url = row['image_url']
  product.active = true
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

users = User.all

i = 0
users.each do |user|
  5.times do 
    random_idx = rand(0...products.length)
    user.products << products[random_idx]
  end
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