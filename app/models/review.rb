class Review < ApplicationRecord
  belongs_to :product

  validates :reviewer, presence: true
  validates :description, presence: true
  validates :rating, presence: true, numericality: {only_integer: true, greater_than: 0, less_than: 6}

  def self.display_rating(rating)
    return "☆" * 5 if rating == 0 
    return "★" * rating
  end
end
