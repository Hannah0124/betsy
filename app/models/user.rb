class User < ApplicationRecord
  has_many :products
  has_many :orders

  validates :name, uniqueness: true, presence: true
  validates :emaiL_address, uniqueness: true, presence: true
  # validates :uid, uniqueness: true, presence: true
end
