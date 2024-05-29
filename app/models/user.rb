class User < ApplicationRecord
  has_many :recipes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :inventory
  has_many :ingredients

  after_create :create_default_inventory

  private

  def create_default_inventory
    create_inventory!
  end
end
