class Recipe < ApplicationRecord
    belongs_to :user
    has_many :meal_plans, dependent: :destroy
end