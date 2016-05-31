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

  it "returns top merchants by sales revenue" do
    create_merchant(2)
    fourth_ranked = Merchant.first
    third_ranked = Merchant.last 
    create_merchant
    second_ranked = Merchant.last
    create_merchant
    first_ranked = Merchant.last

    allow(fourth_ranked).to receive(:sales).and_return(05)
    allow(third_ranked).to receive(:sales).and_return(10)
    allow(second_ranked).to receive(:sales).and_return(15)
    allow(first_ranked).to receive(:sales).and_return(20)
    top_three = Merchant.top_by_revenue(3)

    expect(top_three).to include(first_ranked)
    expect(top_three).to include(second_ranked)
    expect(top_three).to include(third_ranked)
    expect(top_three).not_to include(fourth_ranked)
  end

  it "returns top merchants by number of items" do
    create_merchant(2)
    fourth_ranked = Merchant.first
    third_ranked = Merchant.last 
    create_merchant
    second_ranked = Merchant.last
    create_merchant
    first_ranked = Merchant.last

    allow(fourth_ranked).to receive(:item_count).and_return(05)
    allow(third_ranked).to receive(:item_count).and_return(10)
    allow(second_ranked).to receive(:item_count).and_return(15)
    allow(first_ranked).to receive(:item_count).and_return(20)
    top_three = Merchant.top_by_item_count(3)

    expect(top_three).to include(first_ranked)
    expect(top_three).to include(second_ranked)
    expect(top_three).to include(third_ranked)
    expect(top_three).not_to include(fourth_ranked)
  end

  it "returns revenue by date of transaction" do
    create_merchant
    merchant = Merchant.last
    create_invoice(1, "shipped", 1, merchant.id)
    invoice = Invoice.last
    create_invoice_item(1, 20, 20, 1, invoice.id)
    create_transaction(1, "cc_number", "success", invoice.id)

    today = (Date.today).strftime("%m/%d/%Y")
    yesterday = (Date.yesterday).strftime("%m/%d/%Y")

    revenue_today = merchant.revenue_by_date(today)
    revenue_yesterday = merchant.revenue_by_date(yesterday)

    expect(revenue_today).to eq(400)
    expect(revenue_yesterday).to eq(0)
  end

end
