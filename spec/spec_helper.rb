require 'simplecov'
SimpleCov.start 'rails'
require 'vcr'
require 'webmock/rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

   config.color = true

def create_item(n=1, merchant_id=1, name="Item", description="Description", unit_price=rand(1.0..500))
  n.times do
    Item.create(name: name, description: description, unit_price: unit_price, merchant_id: merchant_id)
  end
  Item.last
end

def create_merchant(n=1, name="Merchant")
  n.times do
    Merchant.create(name: name)
  end
  Merchant.last
end

def create_customer(n=1, first_name="Customer", last_name="Smith")
  n.times do
    Customer.create(first_name: first_name, last_name: last_name)
  end
  Customer.last
end

def create_invoice(n=1, status="shipped", customer_id=1, merchant_id=1)
  n.times do
    Invoice.create(status: status, customer_id: customer_id, merchant_id: merchant_id)
  end
  Invoice.last
end

def create_transaction(n=1, credit_card_number=rand(1111111111111111..9999999999999999).to_s, result="resultat", invoice_id=1)
  n.times do
    Transaction.create(credit_card_number: credit_card_number, result: result, invoice_id: invoice_id)
  end
  Transaction.last
end

def create_invoice_item(n=1, unit_price=rand(123.45..543.21), quantity=rand(1..18), item_id=1, invoice_id=1)
  n.times do
    InvoiceItem.create(unit_price: unit_price, quantity: quantity, item_id: item_id, invoice_id: invoice_id)
  end
  InvoiceItem.last
end

end