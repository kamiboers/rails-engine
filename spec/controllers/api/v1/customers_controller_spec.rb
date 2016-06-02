require 'rails_helper'

RSpec.describe Api::V1::CustomersController, type: :controller do
  describe "#index" do
    it "successfully returns customers index" do
      create_customer(2)
      get :index, format: :json
      customers = JSON.parse(response.body)

      assert_response :success
      assert_equal customers.count, 2
    end
  end

  describe "#show" do
    it "successfully returns customer show" do
      create_customer(2)
      id = Customer.first.id
      get :show, id: id, format: :json
      customer = JSON.parse(response.body)

      assert_response :success
      assert_equal customer["id"], id
    end
  end

  describe "#random" do
    it "successfully returns random customer in database" do
        create_customer(8)
        id_array = Customer.pluck(:id)
        get :random, format: :json
        customer1_id = JSON.parse(response.body)["id"]
        get :random, format: :json
        customer2_id = JSON.parse(response.body)["id"]

        assert_response :success
        expect(id_array).to include(customer1_id)
        expect(customer1_id).not_to eq(customer2_id)
    end
  end

  describe "#find" do
    it "returns customer with id in search parameters" do
      customer = create_customer

      get :find, id: customer.id

      assert_response :success
      expect(response.body).to include(customer.first_name)
      expect(response.body).to include(customer.last_name)
    end

    it "returns customer with created_at in search parameters" do
      customer = create_customer
      date = "12/12/12".to_datetime
      customer.update!(created_at: date)

      get :find, created_at: date

      assert_response :success
      expect(response.body).to include(customer.first_name)
      expect(response.body).to include(customer.last_name)
    end
    
    it "returns customer with updated_at in search parameters" do
      customer = create_customer
      date = "12/12/12".to_datetime
      customer.update!(updated_at: date)

      get :find, updated_at: date

      assert_response :success
      expect(response.body).to include(customer.first_name)
      expect(response.body).to include(customer.last_name)
    end

    it "returns customer with first_name in search parameters" do
      create_customer
      customer = Customer.first

      get :find, first_name: customer.first_name
      assert_response :success
      expect(response.body).to include(customer.id.to_s)
    end

    it "returns customer with last_name in search parameters" do
      create_customer
      customer = Customer.first

      get :find, last_name: customer.last_name
      assert_response :success
      expect(response.body).to include(customer.id.to_s)
    end
  end

  describe "#find_all" do
    it "returns all customers with first_name in search parameters" do
      create_customer(1, "John", "McJohn")
      create_customer(2, "Steve", "McSteve")

      get :find_all, first_name: "Steve"
      selected = JSON.parse(response.body)

      first_selected_name = selected.first["first_name"]
      last_selected_name = selected.last["first_name"]

      assert_response :success
      expect(selected.count).to eq(2)
      expect(first_selected_name).to eq("Steve")
      expect(last_selected_name).to eq("Steve")
    end

    it "returns all customers with first_name in search parameters regardless of case" do
      create_customer(1, "Steve")
      create_customer(1, "sTEVe")
      create_customer(1, "Blue")

      get :find_all, first_name: "steve"
      selected = JSON.parse(response.body)

      first_selected_name = selected.first["first_name"]
      last_selected_name = selected.last["first_name"]

      assert_response :success
      expect(selected.count).to eq(2)
      expect(first_selected_name).to eq("Steve")
      expect(last_selected_name).to eq("sTEVe")
    end

    it "returns all customers with last_name in search parameters regardless of case" do
      create_customer(1, "Steve", "Marshall")
      create_customer(1, "John", "marSHALl")
      create_customer(1, "Steve", "Marks")

      get :find_all, last_name: "marshall"
      selected = JSON.parse(response.body)

      first_selected_name = selected.first["last_name"]
      last_selected_name = selected.last["last_name"]

      assert_response :success
      expect(selected.count).to eq(2)
      expect(first_selected_name).to eq("Marshall")
      expect(last_selected_name).to eq("marSHALl")
    end

    it "returns all customers with created_at in search parameters" do
      customer1 = create_customer(1, "included_first_name")
      customer2 = create_customer(1, "other_included_first_name")
      customer3 = create_customer(1, "excluded_first_name")

      date = "12/12/12".to_datetime
      customer1.update!(created_at: date)
      customer2.update!(created_at: date)

      get :find_all, created_at: date
      results = JSON.parse(response.body)

      assert_response :success
      expect(results.count).to eq(2)
      expect(results.to_s).to include("included_first_name")
      expect(results.to_s).to include("other_included_first_name")
      expect(results.to_s).not_to include("excluded_first_name")
    end
    
  it "returns all customers with updated_at in search parameters" do
      customer1 = create_customer(1, "included_first_name")
      customer2 = create_customer(1, "other_included_first_name")
      customer3 = create_customer(1, "excluded_first_name")

      date = "12/12/12".to_datetime
      customer1.update!(updated_at: date)
      customer2.update!(updated_at: date)

      get :find_all, updated_at: date
      results = JSON.parse(response.body)

      assert_response :success
      expect(results.count).to eq(2)
      expect(results.to_s).to include("included_first_name")
      expect(results.to_s).to include("other_included_first_name")
      expect(results.to_s).not_to include("excluded_first_name")
    end
  end

  describe "#invoices" do
    it "successfully returns specific customer invoice data" do
      create_customer(2)
      customer = Customer.last
      create_invoice
      create_invoice(2, "paid", customer.id)
      invoice = Invoice.last

      get :invoices, id: customer.id

      customer_invoices = JSON.parse(response.body)

      assert_response :success
      expect(customer_invoices.count).to eq(2)
      expect(customer_invoices.last["id"]).to eq(invoice.id)
    end
  end

  describe "#transactions" do
    it "successfully returns specific customer transaction data" do
      create_customer
      customer = Customer.last
      create_invoice(1, "paid", customer.id)
      invoice = Invoice.last
      create_transaction(1, "credit_card_number", "transaction result", invoice.id)
      create_transaction(1, "credit_card_number", "other result", invoice.id)
      transaction = Transaction.last

      get :transactions, id: customer.id
      customer_transactions = JSON.parse(response.body)

      assert_response :success
      expect(customer_transactions.count).to eq(2)
      expect(customer_transactions.to_s).to include("transaction result")
      expect(customer_transactions.to_s).to include("other result")
    end
  end

  describe "#favorite_merchant" do
    it "successfully returns customer's most patronized merchant" do
      customer = create_customer
      merchant1 = create_merchant(1, "Inspector Gadget")
      merchant2 = create_merchant(1, "Penny")
      invoice1 = create_invoice(1, "paid", customer.id, merchant1.id)
      invoice2 = create_invoice(1, "paid", customer.id, merchant1.id)
      invoice3 = create_invoice(1, "paid", customer.id, merchant2.id)
      invoice = Invoice.last
      create_transaction(1, "credit_card_number", "success", invoice1.id)
      create_transaction(1, "credit_card_number", "success", invoice2.id)
      create_transaction(1, "credit_card_number", "success", invoice3.id)

      get :favorite_merchant, id: customer.id
      favorite_merchant = JSON.parse(response.body)

      assert_response :success
      expect(favorite_merchant.to_s).to include("Inspector Gadget")
      expect(favorite_merchant.to_s).not_to include("Penny")
    end
  end


# describe "#create" do
#   it "successfully creates an customer" do
#     assert_equal 0, Customer.count

#     customer_params = { first_name: "MEGATRON"}
#     post :create, customer: customer_params, format: :json
#     customer = Customer.last

#     assert_response :success
#     assert_equal customer.first_name, customer_params[:first_name]
#     assert_equal 1, Customer.count
#   end
# end

# describe "#update" do
#   it "successfully updates an customer" do
#     create_customer
#     id = Customer.first.id
#     previous_name = Customer.first.first_name
#     customer_params = { first_name: "NEW NAME" }

#     put :update, id: id, customer: customer_params, format: :json
#     customer = Customer.find_by(id: id)

#     assert_response :success
#     refute_equal previous_name, customer.first_name
#     assert_equal "NEW NAME", customer.first_name
#   end
# end

# describe "#destroy" do
#   it "successfully deletes an customer" do
#     create_customer
#     assert_equal 1, Customer.count 
#     customer = Customer.last
#     delete :destroy, id: customer.id, format: :json

#     assert_response :success
#     refute Customer.find_by(id: customer.id)
#     assert_equal 0, Customer.count
#   end
# end

end