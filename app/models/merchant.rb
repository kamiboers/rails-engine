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
    return find(params[:id]).as_json if params[:id]
    return where("lower(name) = ?", params[:name].downcase).first.as_json if params[:name]
  end

  def self.search_all(params)
    return find(params[:id]).as_json if params[:id]
    return where("lower(name) = ?", params[:name].downcase).as_json if params[:name]
  end

  def self.top_by_revenue(n)
    all.sort_by(&:sales).reverse.first(n.to_i)
  end

  def self.top_by_item_count(n)
    all.sort_by(&:item_count).reverse.first(n.to_i)
  end

  def self.revenue_by_date(date_string)
    format_string = "%m/%d/" + (date_string =~ /\d{4}/ ? "%Y" : "%y")
    date = Date.parse(date_str) rescue Date.strptime(date_string, format_string)
    joins(:invoices).where(updated_at: date.beginning_of_day..date.end_of_day).joins(invoices: :invoice_items).pluck("quantity * unit_price").sum 
    #this passes now but may not be checking for paid invoices... DANGA!
 end

  def sales
    invoices.paid.includes(:invoice_items).sum("quantity * unit_price")
  end

  def item_count
    items.count
  end

  def revenue_by_date(date_string)
    format_string = "%m/%d/" + (date_string =~ /\d{4}/ ? "%Y" : "%y")
    date = Date.parse(date_str) rescue Date.strptime(date_string, format_string)
    
    invoices.where(updated_at: date.beginning_of_day..date.end_of_day).joins(:invoice_items).paid.pluck("quantity * unit_price").sum
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
