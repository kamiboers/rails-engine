require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  it { should validate_presence_of :quantity }
  it { should validate_presence_of :unit_price }
  it { should validate_presence_of :item_id }
  it { should validate_presence_of :invoice_id }

  it "returns paid or unpaid status of associated invoice" do
    create_invoice
    invoice = Invoice.last
    create_transaction(1, "cc_number", "success", invoice.id)
    create_invoice_item(1, 75, 2, 1, invoice.id)

    expect(Invoice.paid).to eq([invoice])
  end

  it "returns paid or unpaid status of associated invoice" do
    create_invoice
    invoice = Invoice.last
    create_transaction(1, "cc_number", "failed", invoice.id)
    create_invoice_item(1, 75, 2, 1, invoice.id)

    expect(Invoice.paid).to eq([])
  end

   it "returns paid invoice_items from a group" do
    create_invoice
    invoice = Invoice.last
    create_transaction(1, "cc_number", "success", invoice.id)
    transaction2 = Transaction.last
    create_invoice_item(1, 60, 2, 1, invoice.id)
    invoice_item = InvoiceItem.last

    create_invoice
    invoice1 = Invoice.last
    create_transaction(1, "cc_number", "failed", invoice1.id)
    transaction1 = Transaction.last
    create_invoice_item(1, 60, 2, 1, invoice1.id)
    invoice_item1 = InvoiceItem.last

    expect(InvoiceItem.paid).to eq( [InvoiceItem.find(invoice_item.id)] )
    expect(Invoice.paid.count).to eq(1)
  end

end