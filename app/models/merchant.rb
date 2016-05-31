class Merchant < ActiveRecord::Base
  has_many :items
  has_many :invoices
  has_many :transactions, through: :invoices

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
    all.sort_by(&:sales).reverse.first(n)
  end

  def self.top_by_item_count(n)
    all.sort_by(&:item_count).reverse.first(n)
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
    
    binding.pry
    a = invoices.where(updated_at: date.beginning_of_day..date.end_of_day).joins(:invoice_items).paid.pluck(&:total).sum
  end

end
