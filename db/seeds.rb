
require 'csv'

USER_FILE = Rails.root.join('db','seeds','villagers_seeds.csv')

puts "Loading raw product data from #{USER_FILE}"

user_failures = []
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
puts "#{user_failures.length} user failed to save"
