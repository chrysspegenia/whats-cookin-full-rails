class Ingredient < ApplicationRecord
  belongs_to :user
  belongs_to :inventory

  validates :user, presence: true
  validates :inventory, presence: true
end