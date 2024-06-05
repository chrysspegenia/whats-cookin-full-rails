class AddIsUserCreatedToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :isUserCreated, :boolean
  end
end
