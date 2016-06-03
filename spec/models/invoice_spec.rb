require 'rails_helper'

RSpec.describe Invoice, type: :model do
  it { should validate_presence_of :status }
  it { should validate_presence_of :customer_id }
  it { should validate_presence_of :merchant_id }

  it "returns whether successful invoice transaction exists" do
    invoice = create_invoice
    transaction1 = create_transaction(1, "cc_number", "failed", invoice.id)

    expect(invoice.successful).to eq(false)

    transaction2 = create_transaction(1, "cc_number", "success", invoice.id)

    expect(invoice.transactions.count).to eq(2)
    expect(invoice.successful).to eq(true)
  end

  it "returns successful invoices from a group" do
    invoice = create_invoice
    transaction1 = create_transaction(1, "cc_number", "failed", invoice.id)
    invoice1 = create_invoice
    transaction2 = create_transaction(1, "cc_number", "success", invoice1.id)

    expect(Invoice.paid).to eq([Invoice.find(invoice1.id)])
    expect(Invoice.paid.count).to eq(1)
  end

  it "returns successful invoices from a group" do
    invoice = create_invoice
    transaction1 = create_transaction(1, "cc_number", "failed", invoice.id)
    invoice1 = create_invoice
    transaction2 = create_transaction(1, "cc_number", "success", invoice1.id)

    expect(Invoice.successful).to eq([Invoice.find(invoice1.id)])
    expect(Invoice.successful.count).to eq(1)
  end

  it "returns successful invoices from a group by date" do
    invoice = create_invoice
    transaction1 = create_transaction(1, "cc_number", "failed", invoice.id)
    invoice1 = create_invoice
    transaction2 = create_transaction(1, "cc_number", "success", invoice1.id)
    invoice2 = create_invoice
    transaction3 = create_transaction(1, "cc_number", "success", invoice2.id)
    date = "12/12/12".to_datetime
    invoice2.update!(created_at: date, updated_at: date)

    expect(Invoice.successful.count).to eq(2)
    expect(Invoice.successful(date).count).to eq(1)
  end

  it "returns total of invoice_items if successful" do
    invoice = create_invoice
    create_transaction(1, "cc_number", "success", invoice.id)
    create_invoice_item(3, 100, 2, 1, invoice.id)

    expect(invoice.total).to eq(600)
  end

  it "returns 0 as total of invoice's invoice_item if failed" do
    invoice = create_invoice
    create_transaction(1, "cc_number", "failed", invoice.id)
    create_invoice_item(3, 100, 2, 1, invoice.id)

    expect(invoice.total).to eq(0)
  end

  it "returns 0 as total of invoice's invoice_item if no transaction" do
    invoice = create_invoice
    create_invoice_item(3, 100, 2, 1, invoice.id)

    expect(invoice.total).to eq(0)
  end

end
