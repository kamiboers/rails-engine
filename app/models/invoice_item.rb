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

  def self.search(params)
    return find(params[:id]).as_json if params[:id]
    return find_by(invoice_id: params[:invoice_id]).as_json if params[:invoice_id]
  end

end
