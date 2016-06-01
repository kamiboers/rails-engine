require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it { should validate_presence_of :credit_card_number }
  it { should validate_presence_of :result }
  it { should validate_presence_of :invoice_id }

  it "returns whether a group of transactions includes a success" do
    create_transaction(1, "cc_number", "failed")
    transaction1 = Transaction.last
    create_transaction(1, "cc_number", "success")
    transaction2 = Transaction.last

    expect(transaction1.success).to eq(false)
    expect(transaction2.success).to eq(true)
    expect(Transaction.successful).to eq(true)
  end

end
