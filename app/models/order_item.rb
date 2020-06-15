class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :quantity, presence: true

  def total
    return self.quantity * self.product.price
  end

  def mark_complete
    self.complete = true
    self.save

    self.order.check_status
  end

  def mark_cancelled
    self.complete = nil
    #self.(logic for putting back inventory equal to quantity of order item)
    self.save

    self.order.check_status
  end


end
