class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.text :instructions, null: false
      t.string :image_url, null: false
      t.string :public_code, null: false
      t.timestamps null: false
      t.references :user, null: false, foreign_key: true
    end
  end
end
