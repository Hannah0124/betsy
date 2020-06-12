class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true
  validates :price, numericality: {only_integer: true, greater_than: 0}
  validates :inventory, numericality: {only_integer: true, greater_than: 0}
  
  has_and_belongs_to_many :categories
  # belongs_to :user
  has_many :reviews
  has_many :order_items
  has_many :orders, :through => :order_items

  def change_status
    if self.active
      self.update(active: false)
    else 
      self.update(active: true)
    end 
  end

  def num_of_ratings
    return self.reviews.length 
  end


  def average_rating 
    all_reviews = self.reviews

    if all_reviews.empty?
      return 0
    else 
      sum = 0.0
      all_reviews.each do |review| 
        sum += review.rating
      end
      # ratings = all_reviews.reduce(:+) { |review| review.rating }
      return sum / self.num_of_ratings
    end
  end
end