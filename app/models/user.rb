class User < ApplicationRecord
  has_many :products
  has_many :orders

  validates :name, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true
  validates :uid, uniqueness: true, presence: true
end
