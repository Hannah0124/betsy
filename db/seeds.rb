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