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
    it "successfully returns specific merchant data" do
      create_merchant(2)
      id = Merchant.first.id
      get :show, id: id, format: :json
      merchant = JSON.parse(response.body)

      assert_response :success
      assert_equal merchant["id"], id
    end
  end

  describe "#random" do
    it "successfully returns random merchant in database" do
      create_merchant(8)
      id_array = Merchant.pluck(:id)
      get :random, format: :json
      merchant1_id = JSON.parse(response.body)["id"]
      get :random, format: :json
      merchant2_id = JSON.parse(response.body)["id"]
   
      assert_response :success
      expect(id_array).to include(merchant1_id)
      expect(merchant1_id).not_to eq(merchant2_id)
    end
  end

  describe "#find" do
    it "returns merchant with id in search parameters" do
      create_merchant
      merchant = Merchant.first
      
      
      get :find, id: merchant.id

      assert_response :success
      expect(response.body).to include(merchant.name)
    end

    it "returns merchant with name in search parameters" do
      create_merchant
      merchant = Merchant.first
      get :find, name: merchant.name

      assert_response :success
      expect(response.body).to include(merchant.id.to_s)
  end
end

  # describe "#create" do
  #   it "successfully creates an merchant" do
  #     assert_equal 0, Merchant.count

  #     merchant_params = { name: "MEGATRON"}
  #     post :create, merchant: merchant_params, format: :json
  #     merchant = Merchant.last

  #     assert_response :success
  #     assert_equal merchant.name, merchant_params[:name]
  #     assert_equal 1, Merchant.count
  #   end
  # end

  # describe "#update" do
  #   it "successfully updates an merchant" do
  #     create_merchant
  #     id = Merchant.first.id
  #     previous_name = Merchant.first.name
  #     merchant_params = { name: "NEW NAME" }

  #     put :update, id: id, merchant: merchant_params, format: :json
  #     merchant = Merchant.find_by(id: id)

  #     assert_response :success
  #     refute_equal previous_name, merchant.name
  #     assert_equal "NEW NAME", merchant.name
  #   end
  # end

  # describe "#destroy" do
  #   it "successfully deletes an merchant" do
  #     create_merchant
  #     assert_equal 1, Merchant.count 
  #     merchant = Merchant.last
  #     delete :destroy, id: merchant.id, format: :json

  #     assert_response :success
  #     refute Merchant.find_by(id: merchant.id)
  #     assert_equal 0, Merchant.count
  #   end
  # end

end