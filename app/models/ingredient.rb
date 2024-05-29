class Ingredient < ApplicationRecord
  belongs_to :user
  belongs_to :inventory

  validates :name, presence: true
  validates :quantity, presence: true
  validates :user, presence: true
  validates :inventory, presence: true
end