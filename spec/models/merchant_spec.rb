require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it { should validate_presence_of :name }


  it "returns total sales for merchant" do
    create_merchant
    merchant = Merchant.first
    create_invoice(1, "shipped", 1, merchant.id)
    invoice = Invoice.first
    create_invoice_item(1, 50, 2, 1, invoice.id)
    create_invoice_item(1, 100, 2, 1, invoice.id)
    create_transaction(1, "cc", "success", invoice.id)

    expect(merchant.sales).to eq(300)
  end

   it "returns zero total sales for merchant with no successful transactions" do
    create_merchant
    merchant = Merchant.first
    create_invoice(1, "shipped", 1, merchant.id)
    invoice = Invoice.first
    create_invoice_item(1, 50, 2, 1, invoice.id)
    create_invoice_item(1, 100, 2, 1, invoice.id)
    create_transaction(1, "cc", "failed", invoice.id)

    expect(merchant.sales).to eq(0)
  end

end
