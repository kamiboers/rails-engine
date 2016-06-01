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
    return find(params[:id]) if params[:id]
    return find_by(quantity: params[:quantity]) if params[:quantity]
    return find_by(item_id: params[:item_id]) if params[:item_id]
    return find_by(invoice_id: params[:invoice_id]) if params[:invoice_id]
    return find_by(unit_price: (params[:unit_price]).to_f*100) if params[:unit_price]
    return find_by(created_at: params[:created_at].to_datetime) if params[:created_at]
    return find_by(updated_at: params[:updated_at].to_datetime) if params[:updated_at]
  end

  def self.search_all(params)
    return find(params[:id]) if params[:id]
    return where(quantity: params[:quantity]) if params[:quantity]
    return where(item_id: params[:item_id]) if params[:item_id]
    return where(invoice_id: params[:invoice_id]) if params[:invoice_id]
    return where(unit_price: (params[:unit_price]).to_f*100) if params[:unit_price]
    return where(created_at: params[:created_at].to_datetime) if params[:created_at]
    return where(updated_at: params[:updated_at].to_datetime) if params[:updated_at]
  end

  def self.paid
    joins(invoice: :transactions).where(transactions: {result: "success"})
  end

end
