# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# login as user fernando@flexer.com test1234 devise

user = User.find_or_create_by!(email: 'fernando@flexer.com') do |user|
  user.password = 'test1234'
end

ingredient1 = Ingredient.find_or_create_by!(name: 'Tomato') do |ingredient|
  ingredient.quantity = 5
  ingredient.user = user
  ingredient.inventory = user.inventory
end

ingredient2 = Ingredient.find_or_create_by!(name: 'Onion') do |ingredient|
  ingredient.quantity = 3
  ingredient.user = user
  ingredient.inventory = user.inventory
end


