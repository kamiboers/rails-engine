require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  it { should validate_presence_of :quantity }
  it { should validate_presence_of :unit_price }
  it { should validate_presence_of :item_id }
  it { should validate_presence_of :invoice_id }

  it "returns paid or unpaid status of associated invoice" do
    invoice = create_invoice
    create_transaction(1, "cc_number", "success", invoice.id)
    create_invoice_item(1, 75, 2, 1, invoice.id)

    expect(Invoice.successful).to eq([invoice])
  end

  it "returns paid or unpaid status of associated invoice" do
    invoice = create_invoice
    create_transaction(1, "cc_number", "failed", invoice.id)
    create_invoice_item(1, 75, 2, 1, invoice.id)

    expect(Invoice.successful).to eq([])
  end

   it "returns paid invoice_items from a group" do
    invoice = create_invoice
    transaction2 = create_transaction(1, "cc_number", "success", invoice.id)
    invoice_item = create_invoice_item(1, 60, 2, 1, invoice.id)

    invoice1 = create_invoice
    transaction1 = create_transaction(1, "cc_number", "failed", invoice1.id)
    invoice_item1 = create_invoice_item(1, 60, 2, 1, invoice1.id)

    expect(InvoiceItem.successful).to eq( [InvoiceItem.find(invoice_item.id)] )
    expect(Invoice.successful.count).to eq(1)
  end
end