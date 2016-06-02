class Merchant < ActiveRecord::Base
  has_many :items
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates :name, presence: true

  def self.random
    offset(rand(Merchant.count)).first
  end

  def self.search(params)
    return find(params[:id]) if params[:id]
    return where("lower(name) = ?", params[:name].downcase).first if params[:name]
    return find_by(created_at: params[:created_at].to_datetime) if params[:created_at]
    return find_by(updated_at: params[:updated_at].to_datetime) if params[:updated_at]
  end

  def self.search_all(params)
    return [] << find(params[:id]) if params[:id]
    return where("lower(name) = ?", params[:name].downcase) if params[:name]
    return where(created_at: params[:created_at].to_datetime) if params[:created_at]
    return where(updated_at: params[:updated_at].to_datetime) if params[:updated_at]
  end

  def self.top_by_revenue(n)
    all.sort_by(&:sales).reverse.first(n.to_i)
  end

  def self.top_by_item_count(n)
    all.sort_by(&:item_count).reverse.first(n.to_i)
  end

  def self.revenue_by_date(date_string)
    date = (date_string).to_datetime
    day_invoices = Invoice.successful.where(created_at: date).joins(:invoice_items).pluck("quantity * unit_price").sum/100.0
 end

  def sales
    invoices.successful.joins(:invoice_items).pluck("quantity * unit_price").sum/100.0
  end

  def item_count
    invoices.successful.joins(:invoice_items).pluck(:quantity).sum
  end

  def revenue_by_date(date_string)
    date = date_string.to_datetime
    invoices.successful.where(updated_at: date).joins(:invoice_items).pluck("quantity * unit_price").sum/100.0
  end

  def favorite_customer
    a = invoices.paid
    a = a.each_with_object(Hash.new(0)) { |invoice,counts| counts[invoice.customer_id] += 1 }
    a = a.sort_by {|k,v| v}.reverse
    Customer.find(a.first.first)
  end

  def customers_with_pending_invoices
    invoices.joins(:transactions).where(transactions: {result: "failed"}).map { |invoice| invoice.customer }.uniq
  end

end
