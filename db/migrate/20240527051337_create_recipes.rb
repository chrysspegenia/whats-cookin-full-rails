class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.text :instructions, null: false
      t.string :image_url, null: false
      t.text :health_labels, array: true, default: []
      t.float :calories
      t.string :cuisine_type, array: true, default: []
      t.string :meal_type, array: true, default: []
      t.integer :serving
      t.string :url_source
      t.timestamps null: false
      t.references :user, null: false, foreign_key: true
    end
  end
end
