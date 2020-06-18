class Category < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  has_and_belongs_to_many :products, dependent: :nullify

  # def self.search(parameter) 
  #   return Category.where("lower(name) LIKE ? ", "%#{parameter}%") 
  # end

  def self.search_result(parameter) 
    categories = self.where("lower(name) LIKE ? ", "%#{parameter}%") 

    return categories.reduce(0) { |sum, category| sum + category.products.length }
  end
end