require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it { should validate_presence_of :name }


  it "returns total sales for merchant" do
    create_merchant
    merchant = Merchant.first
    create_invoice(1, "shipped", 1, merchant.id)
    invoice = Invoice.first
    create_invoice_item(1, 5000, 2, 1, invoice.id)
    create_invoice_item(1, 10000, 2, 1, invoice.id)
    create_transaction(1, "cc", "success", invoice.id)

    expect(merchant.sales).to eq(300)
  end

   it "returns zero total sales for merchant with no successful transactions" do
    create_merchant
    merchant = Merchant.first
    create_invoice(1, "shipped", 1, merchant.id)
    invoice = Invoice.first
    create_invoice_item(1, 5000, 2, 1, invoice.id)
    create_invoice_item(1, 10000, 2, 1, invoice.id)
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

  it "returns all merchants' revenue by date of transaction" do
    merchant1 = create_merchant
    merchant2 = create_merchant
    date = "12/12/12".to_datetime

    invoice1 = create_invoice(1, "shipped", 1, merchant1.id)
    create_invoice_item(1, 2000, 20, 1, invoice1.id)
    create_transaction(1, "cc_number", "success", invoice1.id)
    invoice1.update(created_at: date, updated_at: date)

    invoice2 = create_invoice(1, "shipped", 1, merchant2.id)
    create_invoice_item(1, 3000, 30, 1, invoice2.id)
    create_transaction(1, "cc_number", "success", invoice2.id)
    invoice2.update(created_at: date, updated_at: date)

    revenue_today = Merchant.revenue_by_date(date)
    revenue_yesterday = Merchant.revenue_by_date(date-1.day)

    expect(revenue_today).to eq(1300)
    expect(revenue_yesterday).to eq(0)
  end

  it "returns merchant revenue by date of transaction" do
    merchant = create_merchant
    invoice = create_invoice(1, "shipped", 1, merchant.id)
    date = "03/03/03".to_datetime
    invoice.update!(created_at: date, updated_at: date)
    create_invoice_item(1, 2000, 20, 1, invoice.id)
    create_transaction(1, "cc_number", "success", invoice.id)

    revenue_today = merchant.revenue_by_date(date)
    revenue_yesterday = merchant.revenue_by_date(date-1.day)

    expect(revenue_today).to eq(400)
    expect(revenue_yesterday).to eq(0)
  end

end
