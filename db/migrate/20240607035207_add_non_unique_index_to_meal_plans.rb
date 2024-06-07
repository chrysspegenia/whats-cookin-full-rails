class AddNonUniqueIndexToMealPlans < ActiveRecord::Migration[7.1]
  def change
    if index_exists?(:meal_plans, [:user_id, :meal_type, :date], unique: true, name: 'index_meal_plans_on_user_id_and_meal_type_and_date')
      remove_index :meal_plans, name: 'index_meal_plans_on_user_id_and_meal_type_and_date'
    end

    add_index :meal_plans, [:user_id, :meal_type, :date], name: 'index_meal_plans_on_user_id_and_meal_type_and_date' unless index_exists?(:meal_plans, [:user_id, :meal_type, :date], name: 'index_meal_plans_on_user_id_and_meal_type_and_date')
  end
end
