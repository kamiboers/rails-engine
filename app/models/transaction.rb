class Transaction < ActiveRecord::Base
  belongs_to :invoice
  validates :credit_card_number, presence: true
  validates :result, presence: true
  validates :invoice_id, presence: true

  def self.random
    offset(rand(Transaction.count)).first
  end

  def self.search(params)
    return find(params[:id]) if params[:id]
    return find_by(credit_card_number: params[:credit_card_number]) if params[:credit_card_number]
    return where("lower(result) = ?", params[:result].downcase).first if params[:result]
    return find_by(invoice_id: params[:invoice_id]) if params[:invoice_id]
    return find_by(created_at: params[:created_at].to_datetime) if params[:created_at]
    return find_by(updated_at: params[:updated_at].to_datetime) if params[:updated_at]
  end

   def self.search_all(params)
    return [] << find(params[:id]) if params[:id]
    return where("lower(result) = ?", params[:result].downcase) if params[:result]
    return where(credit_card_number: params[:credit_card_number]) if params[:credit_card_number]
    return where(invoice_id: params[:invoice_id]) if params[:invoice_id]
    return where(created_at: params[:created_at].to_datetime) if params[:created_at]
    return where(updated_at: params[:updated_at].to_datetime) if params[:updated_at]
  end

  def self.successful
    pluck(:result).include?("success")
  end

  def success
    result == "success"
  end

end