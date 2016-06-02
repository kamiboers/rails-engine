require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  describe "#index" do
    it "successfully returns transactions index" do
      create_transaction(2)
      get :index, format: :json
      transactions = JSON.parse(response.body)

      assert_response :success
      assert_equal transactions.count, 2
    end
  end

  describe "#show" do
    it "successfully returns transaction show" do
      create_transaction(2)
      id = Transaction.first.id
      get :show, id: id, format: :json
      transaction = JSON.parse(response.body)

      assert_response :success
      assert_equal transaction["id"], id
    end
  end

  describe "#random" do
    it "successfully returns random transaction in database" do
      create_transaction(8)
      id_array = Transaction.pluck(:id)
      get :random, format: :json
      transaction1_id = JSON.parse(response.body)["id"]
      get :random, format: :json
      transaction2_id = JSON.parse(response.body)["id"]

      assert_response :success
      expect(id_array).to include(transaction1_id)
      expect(transaction1_id).not_to eq(transaction2_id)
    end
  end

   describe "#find" do
    it "returns transaction with id in search parameters" do
      create_transaction
      transaction = Transaction.first
      
      get :find, id: transaction.id

      assert_response :success
      expect(response.body).to include(transaction.credit_card_number)
      expect(response.body).to include(transaction.result)
    end

    it "returns transaction with credit_card_number in search parameters" do
      transaction = create_transaction

      get :find, invoice_id: transaction.invoice_id

      assert_response :success
      expect(response.body).to include(transaction.id.to_s)
  end
end

  describe "#find_all" do
    it "returns all transactions with credit_card_number in search parameters" do
      create_transaction(1, "4242424242424242")
      create_transaction(2, "1212121212121212")
      
      get :find_all, credit_card_number: "1212121212121212"
      selected = JSON.parse(response.body)

      first_selected_cc = selected.first["credit_card_number"]
      last_selected_cc = selected.last["credit_card_number"]

      assert_response :success
      expect(selected.count).to eq(2)
      expect(first_selected_cc).to eq("1212121212121212")
      expect(last_selected_cc).to eq("1212121212121212")
    end

    it "returns all transactions with result in search parameters" do
      create_transaction(1, "4242424242424242", "paid")
      create_transaction(2, "4242424242424242", "cancelled")
      
      get :find_all, result: "cancelled"
      selected = JSON.parse(response.body)

      first_selected_result = selected.first["result"]
      last_selected_result = selected.last["result"]

      assert_response :success
      expect(selected.count).to eq(2)
      expect(first_selected_result).to eq("cancelled")
      expect(last_selected_result).to eq("cancelled")
    end

    it "returns all transactions with invoice_id in search parameters" do
      create_transaction(1, "4242424242424242", "paid", 5)
      create_transaction(2, "4242424242424242", "paid", 6)
      
      get :find_all, invoice_id: 6
      selected = JSON.parse(response.body)

      first_selected_invoice_id = selected.first["invoice_id"]
      last_selected_invoice_id = selected.last["invoice_id"]

      assert_response :success
      expect(selected.count).to eq(2)
      expect(first_selected_invoice_id).to eq(6)
      expect(last_selected_invoice_id).to eq(6)
    end
end

  describe "#invoice" do
    it "successfully returns transaction's invoice data" do
      invoice = create_invoice(1, "transaction invoice")
      transaction = create_transaction(1, "credit_card_number", "result", invoice.id)

      get :invoice, id: transaction.id
      transaction_invoice = JSON.parse(response.body)

      assert_response :success
      expect(transaction_invoice.to_s).to include("transaction invoice")
    end
  end

# describe "#create" do
#   it "successfully creates an transaction" do
#     assert_equal 0, Transaction.count

#     transaction_params = { credit_card_number: "Computer", description: "awesome computer" }
#     post :create, transaction: transaction_params, format: :json
#     transaction = Transaction.last

#     assert_response :success
#     assert_equal transaction.credit_card_number, transaction_params[:credit_card_number]
#     assert_equal 1, Transaction.count
#   end
# end

# describe "#update" do
#   it "successfully updates an transaction" do
#     create_transaction
#     id = Transaction.first.id
#     previous_credit_card_number = Transaction.first.credit_card_number
#     transaction_params = { credit_card_number: "1234567876543218" }

#     put :update, id: id, transaction: transaction_params, format: :json
#     transaction = Transaction.find_by(id: id)

#     assert_response :success
#     refute_equal previous_credit_card_number, transaction.credit_card_number
#     assert_equal "1234567876543218", transaction.credit_card_number
#   end
# end

# describe "#destroy" do
#   it "successfully deletes an transaction" do
#     create_transaction
#     assert_equal 1, Transaction.count 
#     transaction = Transaction.last
#     delete :destroy, id: transaction.id, format: :json

#     assert_response :success
#     refute Transaction.find_by(id: transaction.id)
#     assert_equal 0, Transaction.count
#   end
# end

end