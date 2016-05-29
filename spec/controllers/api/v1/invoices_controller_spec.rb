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

  #   it "returns invoice with cc_number in search parameters" do
  #     create_invoice
  #     invoice = Invoice.first

  #     get :find, invoice_id: invoice.invoice_id

  #     assert_response :success
  #     expect(response.body).to include(invoice.id.to_s)
  # end
end

  describe "#find_all" do
    it "returns all invoices with status in search parameters, case insensitive" do
      create_invoice(1, "shipped")
      create_invoice(2, "pending")
      
      get :find_all, status: "PENDING"
      selected = JSON.parse(response.body)["invoices"]
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
      selected = JSON.parse(response.body)["invoices"]
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
      selected = JSON.parse(response.body)["invoices"]
      first_selected_merchant_id = selected.first["merchant_id"]
      last_selected_merchant_id = selected.last["merchant_id"]

      assert_response :success
      expect(selected.count).to eq(2)
      expect(first_selected_merchant_id).to eq(27)
      expect(last_selected_merchant_id).to eq(27)
    end

end

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