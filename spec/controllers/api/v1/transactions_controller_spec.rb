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
      create_transaction(10)
      id_array = Transaction.pluck(:id)
      get :random, format: :json
      id1 = JSON.parse(response.body)["id"]
      get :random, format: :json
      id2 = JSON.parse(response.body)["id"]
      get :random, format: :json
      id3 = JSON.parse(response.body)["id"]
      unique_results = [id1, id2, id3].uniq.count

      assert_response :success
      expect(id_array).to include(id1)
      expect(unique_results).not_to eq(1)
    end
  end

   describe "#find" do
    it "returns transaction with id in search parameters" do
      transaction = create_transaction
      
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

    it "returns transaction with created_at in search parameters" do
      transaction = create_transaction(1, "4444444444444444")
      date = "12/12/12".to_datetime
      transaction.update!(created_at: date)

      get :find, created_at: date

      assert_response :success
      expect(response.body).to include(transaction.id.to_s)
      expect(response.body).to include("4444444444444444")
    end
    
    it "returns transaction with updated_at in search parameters" do
      transaction = create_transaction(1, "8888888888888888")
      date = "12/12/12".to_datetime
      transaction.update!(updated_at: date)

      get :find, updated_at: date

      assert_response :success
      expect(response.body).to include(transaction.id.to_s)
      expect(response.body).to include("8888888888888888")
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

    it "returns all transactions with created_at in search parameters" do
      transaction1 = create_transaction(1, "included_cc_number")
      transaction2 = create_transaction(1, "other_included_cc_number")
      transaction3 = create_transaction(1, "excluded_cc_number")

      date = "12/12/12".to_datetime
      transaction1.update!(created_at: date)
      transaction2.update!(created_at: date)

      get :find_all, created_at: date
      results = JSON.parse(response.body)

      assert_response :success
      expect(results.count).to eq(2)
      expect(results.to_s).to include("included_cc_number")
      expect(results.to_s).to include("other_included_cc_number")
      expect(results.to_s).not_to include("excluded_cc_number")
    end
    
  it "returns all transactions with updated_at in search parameters" do
      transaction1 = create_transaction(1, "included_cc_number")
      transaction2 = create_transaction(1, "other_included_cc_number")
      transaction3 = create_transaction(1, "excluded_cc_number")

      date = "12/12/12".to_datetime
      transaction1.update!(updated_at: date)
      transaction2.update!(updated_at: date)

      get :find_all, updated_at: date
      results = JSON.parse(response.body)

      assert_response :success
      expect(results.count).to eq(2)
      expect(results.to_s).to include("included_cc_number")
      expect(results.to_s).to include("other_included_cc_number")
      expect(results.to_s).not_to include("excluded_cc_number")
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
end