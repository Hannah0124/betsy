class Review < ApplicationRecord
  belongs_to :product

  validates :description, presence: true
  validates :rating, presence: true
end
