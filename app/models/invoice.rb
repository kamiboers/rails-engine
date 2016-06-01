class Invoice < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  validates :status, presence: true
  validates :customer_id, presence: true
  validates :merchant_id, presence: true

  def self.random
    offset(rand(Invoice.count)).first
  end

  def self.search(params)
    return find(params[:id])if params[:id]
    return where("lower(status) = ?", params[:status].downcase).first if params[:status]
    return find_by(customer_id: params[:customer_id])if params[:customer_id]
    return find_by(merchant_id: params[:merchant_id])if params[:merchant_id]
    return find_by(created_at: params[:created_at].to_datetime) if params[:created_at]
    return find_by(updated_at: params[:updated_at].to_datetime) if params[:updated_at]
  end

   def self.search_all(params)
    return [] << find(params[:id]) if params[:id]
    return where("lower(status) = ?", params[:status].downcase)if params[:status]
    return where(customer_id: params[:customer_id])if params[:customer_id]
    return where(merchant_id: params[:merchant_id])if params[:merchant_id]
    return where(created_at: params[:created_at].to_datetime) if params[:created_at]
    return where(updated_at: params[:updated_at].to_datetime) if params[:updated_at]
  end

  def successful
    transactions.successful
  end

  def self.paid
    joins(:transactions).where(transactions: { result: "success" })
  end

  def total
    successful ? invoice_items.sum("quantity * unit_price") : 0
  end

# invoices.successful.joins(:invoice_items).sum("quantity * unit_price").to_f
end