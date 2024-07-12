class AddIsMeasureInIngredients < ActiveRecord::Migration[7.1]
  def change
    add_column :ingredients, :measure, :string, default: ''
  end
end
