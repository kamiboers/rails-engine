class Transaction < ActiveRecord::Base
  belongs_to :invoice
  validates :cc_number, presence: true
  validates :result, presence: true
  validates :invoice_id, presence: true

  def self.random
    offset(rand(Transaction.count)).first
  end

  def self.search(params)
    return find(params[:id]).as_json if params[:id]
    return find_by(invoice_id: params[:invoice_id]).as_json if params[:invoice_id]
  end

end
