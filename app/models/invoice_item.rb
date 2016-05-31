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
    return find_by(quantity: params[:quantity]).as_json if params[:quantity]
    return find_by(unit_price: params[:unit_price]).as_json if params[:unit_price]
    return find_by(item_id: params[:item_id]).as_json if params[:item_id]
    return find_by(invoice_id: params[:invoice_id]).as_json if params[:invoice_id]
  end

  def self.search_all(params)
    return find(params[:id]).as_json if params[:id]
    return where(quantity: params[:quantity]).as_json if params[:quantity]
    return where(unit_price: params[:unit_price]).as_json if params[:unit_price]
    return where(item_id: params[:item_id]).as_json if params[:item_id]
    return where(invoice_id: params[:invoice_id]).as_json if params[:invoice_id]
  end

  def self.paid
    joins(invoice: :transactions).where(transactions: {result: "success"})
  end

end
