class AddIsGroceryItem < ActiveRecord::Migration[7.1]
  def change
    add_column :ingredients, :is_grocery_item, :boolean, default: false
  end
end
