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
    return find(params[:id]).as_json if params[:id]
    return where("lower(name) = ?", params[:name].downcase).first.as_json if params[:name]
    return where("lower(description) like ?", "%" + params[:description].downcase + "%").first.as_json if params[:description]
    return find_by(unit_price: params[:unit_price]).as_json if params[:unit_price]
    return find_by(merchant_id: params[:merchant_id]).as_json if params[:merchant_id]
  end

   def self.search_all(params)
    return find(params[:id]).as_json if params[:id]
    return where("lower(name) = ?", params[:name].downcase).as_json if params[:name]
    return where("lower(description) like ?", "%" + params[:description].downcase + "%").as_json if params[:description]
    return where(unit_price: params[:unit_price]).as_json if params[:unit_price]
    return where(merchant_id: params[:merchant_id]).as_json if params[:merchant_id]
  end
  
end
