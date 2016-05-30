class Merchant < ActiveRecord::Base
  has_many :items
  has_many :invoices
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

  def return_items
    items.as_json
  end

  def return_invoices
    invoices.as_json
  end

end
