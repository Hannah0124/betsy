class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true
  # belongs_to :user
  has_and_belongs_to_many :categories
  has_many :reviews
  has_many :order_items
  has_many :orders, :through => :order_items
end