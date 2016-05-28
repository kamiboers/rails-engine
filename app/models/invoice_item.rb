class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :item
  validates :quantity, presence: true
  validates :unit_price, presence: true
  validates :item_id, presence: true
  validates :invoice_id, presence: true


  def self.random
    offset(rand(InvoiceItem.count)).first
  end

end
