class Customer < ActiveRecord::Base
  has_many :invoices
  validates :first_name, presence: true
  validates :last_name, presence: true

  def self.random
    offset(rand(Customer.count)).first
  end

  def self.search(params)
    return self.find(params[:id]).as_json if params[:id]
    return self.find_by(first_name: params[:first_name]).as_json if params[:first_name]
    return self.find_by(last_name: params[:last_name]).as_json if params[:last_name]
  end

end
