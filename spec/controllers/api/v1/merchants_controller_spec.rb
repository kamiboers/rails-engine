require 'rails_helper'

RSpec.describe Api::V1::MerchantsController, type: :controller do
  describe "#index" do
    it "successfully returns merchants index" do
      create_merchant(2)
      get :index, format: :json
      merchants = JSON.parse(response.body)

      assert_response :success
      assert_equal merchants.count, 2
    end
  end

  describe "#show" do
    it "successfully returns merchant show" do
      create_merchant(2)
      id = Merchant.first.id
      get :show, id: id, format: :json
      merchant = JSON.parse(response.body)

      assert_response :success
      assert_equal merchant["id"], id
    end
  end

  describe "#create" do
    it "successfully creates an merchant" do
      assert_equal 0, Merchant.count

      merchant_params = { name: "MEGATRON"}
      post :create, merchant: merchant_params, format: :json
      merchant = Merchant.last

      assert_response :success
      assert_equal merchant.name, merchant_params[:name]
      assert_equal 1, Merchant.count
    end
  end

  describe "#update" do
    it "successfully updates an merchant" do
      create_merchant
      id = Merchant.first.id
      previous_name = Merchant.first.name
      merchant_params = { name: "NEW NAME" }

      put :update, id: id, merchant: merchant_params, format: :json
      merchant = Merchant.find_by(id: id)

      assert_response :success
      refute_equal previous_name, merchant.name
      assert_equal "NEW NAME", merchant.name
    end
  end

  describe "#destroy" do
    it "successfully deletes an merchant" do
      create_merchant
      assert_equal 1, Merchant.count 
      merchant = Merchant.last
      delete :destroy, id: merchant.id, format: :json

      assert_response :success
      refute Merchant.find_by(id: merchant.id)
      assert_equal 0, Merchant.count
    end
  end

end