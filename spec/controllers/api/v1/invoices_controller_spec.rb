require 'rails_helper'

RSpec.describe Api::V1::InvoicesController, type: :controller do
  describe "#index" do
    it "successfully returns invoices index" do
      create_invoice(2)
      get :index, format: :json
      invoices = JSON.parse(response.body)

      assert_response :success
      assert_equal invoices.count, 2
    end
  end

  describe "#show" do
    it "successfully returns invoice show" do
      create_invoice(2)
      id = Invoice.first.id
      get :show, id: id, format: :json
      invoice = JSON.parse(response.body)

      assert_response :success
      assert_equal invoice["id"], id
    end
  end

  describe "#random" do
    it "successfully returns random invoice in database" do
      create_invoice(8)
      id_array = Invoice.pluck(:id)
      get :random, format: :json
      invoice1_id = JSON.parse(response.body)["id"]
      get :random, format: :json
      invoice2_id = JSON.parse(response.body)["id"]

      assert_response :success
      expect(id_array).to include(invoice1_id)
      expect(invoice1_id).not_to eq(invoice2_id)
    end
  end

  describe "#find" do
    it "returns invoice with id in search parameters" do
      create_invoice
      invoice = Invoice.first

      get :find, id: invoice.id

      assert_response :success
      expect(response.body).to include(invoice.status)
      expect(response.body).to include(invoice.customer_id.to_s)
      expect(response.body).to include(invoice.merchant_id.to_s)
    end

    it "returns invoice with status in search parameters" do
      create_invoice(1, "paid")
      create_invoice(1, "pending")
      invoice = Invoice.last

      get :find, status: "pending"

      assert_response :success
      expect(response.body).to include(invoice.id.to_s)
    end

    it "returns invoice with customer_id in search parameters" do
      create_invoice(1, "paid", 1)
      create_invoice(1, "pending", 22)
      invoice = Invoice.last

      get :find, customer_id: 22

      assert_response :success
      expect(response.body).to include(invoice.id.to_s)
    end

    it "returns invoice with merchant_id in search parameters" do
      create_invoice(1, "paid", 1, 1)
      create_invoice(1, "pending", 1, 66)
      invoice = Invoice.last

      get :find, merchant_id: 66

      assert_response :success
      expect(response.body).to include(invoice.id.to_s)
    end

    it "returns invoice with created_at in search parameters" do
      invoice = create_invoice(1, "fake_status")
      date = "12/12/12".to_datetime
      invoice.update!(created_at: date)

      get :find, created_at: date

      assert_response :success
      expect(response.body).to include(invoice.id.to_s)
      expect(response.body).to include("fake_status")
    end
    
    it "returns invoice with updated_at in search parameters" do
      invoice = create_invoice(1, "fake_status")
      date = "12/12/12".to_datetime
      invoice.update!(updated_at: date)

      get :find, updated_at: date

      assert_response :success
      expect(response.body).to include(invoice.id.to_s)
      expect(response.body).to include("fake_status")
    end

  end

  describe "#find_all" do
    it "returns all invoices with status in search parameters, case insensitive" do
      create_invoice(1, "shipped")
      create_invoice(2, "pending")

      get :find_all, status: "PENDING"
      selected = JSON.parse(response.body)
      first_selected_status = selected.first["status"]
      last_selected_status = selected.last["status"]

      assert_response :success
      expect(selected.count).to eq(2)
      expect(first_selected_status).to eq("pending")
      expect(last_selected_status).to eq("pending")
    end

    it "returns all invoices with customer_id in search parameters, case insensitive" do
      create_invoice(1, 5.00, 5)
      create_invoice(2, 5.00, 6)

      get :find_all, customer_id: 6
      selected = JSON.parse(response.body)
      first_selected_customer_id = selected.first["customer_id"]
      last_selected_customer_id = selected.last["customer_id"]

      assert_response :success
      expect(selected.count).to eq(2)
      expect(first_selected_customer_id).to eq(6)
      expect(last_selected_customer_id).to eq(6)
    end

    it "returns all invoices with merchant_id in search parameters, case insensitive" do
      create_invoice(1, 5.00, 5, 8)
      create_invoice(2, 5.00, 5, 27)

      get :find_all, merchant_id: 27
      selected = JSON.parse(response.body)
      first_selected_merchant_id = selected.first["merchant_id"]
      last_selected_merchant_id = selected.last["merchant_id"]

      assert_response :success
      expect(selected.count).to eq(2)
      expect(first_selected_merchant_id).to eq(27)
      expect(last_selected_merchant_id).to eq(27)
    end

    it "returns returns all invoices with created_at in search parameters" do
      invoice1 = create_invoice(1, "included_status")
      invoice2 = create_invoice(1, "other_included_status")
      invoice3 = create_invoice(1, "excluded_status")

      date = "12/12/12".to_datetime
      invoice1.update!(created_at: date)
      invoice2.update!(created_at: date)

      get :find_all, created_at: date
      results = JSON.parse(response.body)

      assert_response :success
      expect(results.count).to eq(2)
      expect(results.to_s).to include("included_status")
      expect(results.to_s).to include("other_included_status")
      expect(results.to_s).not_to include("excluded_status")
    end
    
    it "returns all invoices with updated_at in search parameters" do
      invoice1 = create_invoice(1, "included_status")
      invoice2 = create_invoice(1, "other_included_status")
      invoice3 = create_invoice(1, "excluded_status")

      date = "12/12/12".to_datetime
      invoice1.update!(updated_at: date)
      invoice2.update!(updated_at: date)

      get :find_all, updated_at: date
      results = JSON.parse(response.body)

      assert_response :success
      expect(results.count).to eq(2)
      expect(results.to_s).to include("included_status")
      expect(results.to_s).to include("other_included_status")
      expect(results.to_s).not_to include("excluded_status")
    end
  end

  describe "#transactions" do
    it "successfully returns specific invoice transaction data" do
      create_invoice(2)
      invoice1 = Invoice.first
      invoice2 = Invoice.last
      create_transaction(1, "credit_card_number", "complete", invoice1.id)
      create_transaction(2, "credit_card_number", "pending", invoice2.id)

      get :transactions, id: invoice1.id
      invoice1_transactions = JSON.parse(response.body)
      get :transactions, id: invoice2.id
      invoice2_transactions = JSON.parse(response.body)

      assert_response :success
      expect(invoice1_transactions.count).to eq(1)
      expect(invoice1_transactions.to_s).to include("complete")
      expect(invoice2_transactions.count).to eq(2)
      expect(invoice2_transactions.to_s).to include("pending")
    end
  end

  describe "#invoice_items" do
    it "successfully returns specific invoice invoice_item data" do
      create_invoice(2)
      invoice1 = Invoice.first
      invoice2 = Invoice.last
      create_invoice_item(1, 1099, 2, 3, invoice1.id)
      create_invoice_item(2, 2077, 2, 3, invoice2.id)

      get :invoice_items, id: invoice1.id
      invoice1_invoice_items = JSON.parse(response.body)
      get :invoice_items, id: invoice2.id
      invoice2_invoice_items = JSON.parse(response.body)

      assert_response :success
      expect(invoice1_invoice_items.count).to eq(1)
      expect(invoice1_invoice_items.to_s).to include("10.99")
      expect(invoice2_invoice_items.count).to eq(2)
      expect(invoice2_invoice_items.to_s).to include("20.77")
    end
  end

  describe "#items" do
    it "successfully returns specific invoice item data" do
      create_invoice
      invoice = Invoice.last
      create_item(1, 1, "Invoice Item")
      item1 = Item.last
      create_item(1, 1, "Other Invoice Item")
      item2 = Item.last

      create_invoice_item(1, 10000, 3, item1.id, invoice.id)
      create_invoice_item(1, 10000, 3, item2.id, invoice.id)

      get :items, id: invoice.id
      found_invoice_items = JSON.parse(response.body)

      assert_response :success
      expect(found_invoice_items.count).to eq(2)
      expect(found_invoice_items.to_s).to include("Invoice Item")
      expect(found_invoice_items.to_s).to include("Other Invoice Item")
    end
  end

  describe "#customer" do
    it "successfully returns specific invoice customer data" do
      create_customer(1, "John")
      create_customer(1, "Susan")
      customer1 = Customer.first
      customer2 = Customer.last
      create_invoice(1, "paid", customer1.id)
      create_invoice(1, "pending", customer2.id)
      invoice1 = Invoice.first
      invoice2 = Invoice.last

      get :customer, id: invoice1.id
      invoice1_customer = JSON.parse(response.body)
      get :customer, id: invoice2.id
      invoice2_customer = JSON.parse(response.body)

      assert_response :success
      expect(invoice1_customer.to_s).to include("John")
      expect(invoice2_customer.to_s).to include("Susan")
    end
  end

  describe "#merchant" do
    it "successfully returns specific invoice merchant data" do
      create_merchant(1, "MEGATRON")
      create_merchant(1, "Captain Planet")
      merchant1 = Merchant.first
      merchant2 = Merchant.last
      create_invoice(1, "paid", 1, merchant1.id)
      create_invoice(1, "pending", 1, merchant2.id)
      invoice1 = Invoice.first
      invoice2 = Invoice.last

      get :merchant, id: invoice1.id
      invoice1_merchant = JSON.parse(response.body)
      get :merchant, id: invoice2.id
      invoice2_merchant = JSON.parse(response.body)

      assert_response :success
      expect(invoice1_merchant.to_s).to include("MEGATRON")
      expect(invoice2_merchant.to_s).to include("Captain Planet")
    end
  end


######################################################################

# describe "#create" do
#   it "successfully creates an invoice" do
#     assert_equal 0, Invoice.count

#     invoice_params = { status: "AMAZEBALLS" }
#     post :create, invoice: invoice_params, format: :json
#     invoice = Invoice.last

#     assert_response :success
#     assert_equal invoice.status, invoice_params[:status]
#     assert_equal 1, Invoice.count
#   end
# end

# describe "#update" do
#   it "successfully updates an invoice" do
#     create_invoice
#     id = Invoice.first.id
#     previous_status = Invoice.first.status
#     invoice_params = { status: "ROCKIN' IT" }

#     put :update, id: id, invoice: invoice_params, format: :json
#     invoice = Invoice.find_by(id: id)

#     assert_response :success
#     refute_equal previous_status, invoice.status
#     assert_equal "ROCKIN' IT", invoice.status
#   end
# end

# describe "#destroy" do
#   it "successfully deletes an invoice" do
#     create_invoice
#     assert_equal 1, Invoice.count 
#     invoice = Invoice.last
#     delete :destroy, id: invoice.id, format: :json

#     assert_response :success
#     refute Invoice.find_by(id: invoice.id)
#     assert_equal 0, Invoice.count
#   end
# end

end