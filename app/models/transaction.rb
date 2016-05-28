class Transaction < ActiveRecord::Base
  belongs_to :invoice
  validates :cc_number, presence: true
  validates :result, presence: true
  validates :invoice_id, presence: true

  def self.random
    offset(rand(Transaction.count)).first
  end

end
