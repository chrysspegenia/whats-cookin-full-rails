class MealPlan < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  enum meal_type: { breakfast: 'breakfast', lunch: 'lunch', dinner: 'dinner' }
  validates :date, presence: true
end
