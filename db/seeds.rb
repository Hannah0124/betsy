# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

villager_file = File.read(Rails.root.join('db', 'seeds', 'villagers_seeds.csv'))
# puts csv_text
villager_list = CSV.parse(villager_file, :headers => true, :encoding => 'ISO-8859-1')

villager_list.each do |row|
  u = User.new
  u.name = row['name']
  u.emaiL_address = row['full_id']
  u.username = row['id']
  u.save
end

puts "There are now #{User.count} rows in the users table"


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