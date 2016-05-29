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
    return self.find(params[:id]).as_json if params[:id]
    return self.find_by(name: params[:name]).as_json if params[:name]
    return self.find_by(description: params[:description]).as_json if params[:description]
  end

end
