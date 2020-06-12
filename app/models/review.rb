class Review < ApplicationRecord
  belongs_to :product

  validates :description, presence: true
  validates :rating, presence: true, numericality: {only_integer: true, greater_than: 0, less_than: 6}

  def self.display_rating(rating)
    return "★" * rating
  end
end
