require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it { should validate_presence_of :cc_number }
  it { should validate_presence_of :result }
  it { should validate_presence_of :invoice_id }

  it "returns only successful transactions with #successful" do
    create_transaction(1, "cc_number", "failed")
    create_transaction(2, "cc_number", "success")

    expect(Transaction.successful.count).to eq(2)
  end

end
