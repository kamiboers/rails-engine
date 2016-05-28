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