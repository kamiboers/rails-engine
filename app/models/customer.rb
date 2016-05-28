class Customer < ActiveRecord::Base
  has_many :invoices
  validates :first_name, presence: true
  validates :last_name, presence: true

  def self.random
    offset(rand(Customer.count)).first
  end

end
