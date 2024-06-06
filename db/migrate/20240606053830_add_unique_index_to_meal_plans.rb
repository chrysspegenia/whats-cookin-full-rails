class AddUniqueIndexToMealPlans < ActiveRecord::Migration[7.1]
  def change
    add_index :meal_plans, [:user_id, :meal_type, :date], unique: true, name: 'index_meal_plans_on_user_id_and_meal_type_and_date'
  end
end
