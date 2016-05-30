require 'rails_helper'

RSpec.describe Invoice, type: :model do
  it { should validate_presence_of :status }
  it { should validate_presence_of :customer_id }
  it { should validate_presence_of :merchant_id }

  it "returns whether successful invoice transaction exists" do
    create_invoice
    invoice = Invoice.last
    create_transaction(1, "cc_number", "failed", invoice.id)
    transaction1 = Transaction.last

    expect(invoice.successful).to eq(false)

    create_transaction(1, "cc_number", "success", invoice.id)
    transaction2 = Transaction.last

    expect(invoice.successful).to eq(true)
  end

end
