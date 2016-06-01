class Item < ActiveRecord::Base
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  validates :merchant_id, presence: true

  def self.random
    offset(rand(Item.count)).first
  end

  def self.search(params)
    return find(params[:id]) if params[:id]
    return where("lower(name) = ?", params[:name].downcase).first if params[:name]
    return where("lower(description) like ?", "%" + params[:description].downcase + "%").first if params[:description]
    return find_by(merchant_id: params[:merchant_id]) if params[:merchant_id]
    return find_by(unit_price: (params[:unit_price]).to_f*100) if params[:unit_price]
    return find_by(created_at: params[:created_at].to_datetime) if params[:created_at]
    return find_by(updated_at: params[:updated_at].to_datetime) if params[:updated_at]  
  end

   def self.search_all(params)
    return find(params[:id]) if params[:id]
    return where("lower(name) = ?", params[:name].downcase) if params[:name]
    return where("lower(description) like ?", "%" + params[:description].downcase + "%") if params[:description]
    return where(merchant_id: params[:merchant_id]) if params[:merchant_id]
    return where(unit_price: (params[:unit_price]).to_f*100) if params[:unit_price]
    return where(created_at: params[:created_at].to_datetime) if params[:created_at]
    return where(updated_at: params[:updated_at].to_datetime) if params[:updated_at]
  end

  def self.top_by_revenue(n)
    all.sort_by(&:revenue).reverse.first(n.to_i)
  end

  def self.top_by_items_sold(n)
    all.sort_by(&:number_sold).reverse.first(n.to_i)
  end

  def revenue
    raw_revenue = invoice_items.joins(invoice: :transactions).where(transactions: {result: "success"}).sum("quantity * unit_price")
    raw_revenue/100.0
  end

  def number_sold
    invoice_items.joins(invoice: :transactions).where(transactions: {result: "success"}).sum(:quantity)
  end

  def best_day
    day_hash = self.invoice_items.joins(invoice: :transactions).where(transactions: {result: "success"}).group_by { |u| u.created_at.strftime("%d/%m/%y") }
    day = day_hash.sort_by { |key, value| value.sum { |u| u.quantity } }.reverse.first.first
    return Date.parse(day)
  end
  
end
