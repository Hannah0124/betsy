class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: {only_integer: true, greater_than: 0}
  validates :inventory, numericality: {only_integer: true, greater_than: 0}
  
  
  belongs_to :user
  has_many :reviews, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :orders, :through => :order_items
  has_and_belongs_to_many :categories, dependent: :destroy

  def change_status
    if self.active
      self.update!(active: false)
    else 
      self.update!(active: true)
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
      ratings = all_reviews.sum { |review| review.rating }
      avg_rating = (ratings / self.num_of_ratings.to_f)
      return avg_rating.round(1)
    end
  end

  def display_categories 
    return self.categories.map { |category| category.name }.join(", ")
  end

<<<<<<< HEAD
  def return(stock)
    unless stock < 1
      self.inventory += stock
      self.save
    end
=======
  def self.top_rated_products
    result = self.all.sort_by { |product| 
      product.num_of_ratings * product.average_rating
    }.reverse

    return result.first(50)
>>>>>>> master
  end
end