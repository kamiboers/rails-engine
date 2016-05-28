class Invoice < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :customer
  has_many :invoice_items
  validates :status, presence: true
  validates :customer_id, presence: true
  validates :merchant_id, presence: true

  def self.random
    offset(rand(Invoice.count)).first
  end

end
