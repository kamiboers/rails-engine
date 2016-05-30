require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  it { should validate_presence_of :quantity }
  it { should validate_presence_of :unit_price }
  it { should validate_presence_of :item_id }
  it { should validate_presence_of :invoice_id }

  it "returns subtotal of its line item" do
    create_invoice_item(1, 50.01, 10)
    invoice_item = InvoiceItem.last

    expect(invoice_item.subtotal).to eq (500.10)
  end

end