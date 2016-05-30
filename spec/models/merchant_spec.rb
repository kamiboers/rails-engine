require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it { should validate_presence_of :name }

  # it "returns only transactions with successful result with successful_transaction method" do
  #   create_merchant
  #   merchant = Merchant.last
  #   create_invoice(1, "paid", 1, merchant.id)
  #   invoice = Invoice.last
  #   create_transaction(1, "cc_number", "failed", invoice.id)
  #   create_transaction(2, "0123456789101112", "success", invoice.id)
  #   successes = merchant.transactions

  #   expect(successes.count).to eq(2)
  #   expect(successes.pluck(:cc_number)).to include("0123456789101112")
  #   expect(successes.pluck(:cc_number)).not_to include("cc_number")
  # end

end
