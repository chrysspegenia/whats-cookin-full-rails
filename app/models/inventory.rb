class Inventory < ApplicationRecord
  belongs_to :user
  has_many :ingredients, dependent: :destroy

  validates :user, presence: true
  validates :user_id, uniqueness: true
end