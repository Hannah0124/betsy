class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true
  validates :inventory, numericality: {only_integer: true, greater_than: 0}
  # belongs_to :user
  has_and_belongs_to_many :categories
  has_many :reviews
  has_many :order_items
  has_many :orders, :through => :order_items
end