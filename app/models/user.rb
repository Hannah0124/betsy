class User < ApplicationRecord
  has_many :products
  has_many :orders

  # validates :name, uniqueness: true, presence: true
  # validates :emaiL_address, uniqueness: true, presence: true
  # validates :uid, uniqueness: true, presence: true


  def self.build_from_github(auth_hash)
    user = User.new
    user.uid = auth_hash[:uid]
    user.provider = "github"
    user.username = auth_hash["info"]["name"]
    user.name = auth_hash["info"]["nickname"]
    user.emaiL_address = auth_hash["info"]["email"]

    return user
  end

  include PgSearch
  pg_search_scope :search_by_full_name, against:[:name]
end
