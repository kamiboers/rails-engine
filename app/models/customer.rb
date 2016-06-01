class Customer < ActiveRecord::Base
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :merchants, through: :invoices

  validates :first_name, presence: true
  validates :last_name, presence: true

  def self.random
    offset(rand(Customer.count)).first
  end

  def self.search(params)
    return find(params[:id]) if params[:id]
    return where("lower(first_name) = ?", params[:first_name].downcase).first if params[:first_name]
    return where("lower(last_name) = ?", params[:last_name].downcase).first if params[:last_name]
    return find_by(created_at: params[:created_at].to_datetime) if params[:created_at]
    return find_by(updated_at: params[:updated_at].to_datetime) if params[:updated_at]
  end

  def self.search_all(params)
    return find(params[:id]) if params[:id]
    return where("lower(first_name) = ?", params[:first_name].downcase) if params[:first_name]
    return where("lower(last_name) = ?", params[:last_name].downcase) if params[:last_name]
    return where(created_at: params[:created_at].to_datetime) if params[:created_at]
    return where(updated_at: params[:updated_at].to_datetime) if params[:updated_at]
  end

  def favorite_merchant
    merchant_hash = invoices.paid.group_by { |i| i.merchant }
    merchant_hash.sort_by {|k, v| v.count }.reverse.first.first
  end

end
