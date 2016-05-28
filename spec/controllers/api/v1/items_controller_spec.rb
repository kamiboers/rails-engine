require 'rails_helper'

RSpec.describe Api::V1::ItemsController, type: :controller do
  describe "#index" do
    it "successfully returns items index" do
      create_item(2)
      get :index, format: :json
      items = JSON.parse(response.body)

      assert_response :success
      assert_equal items.count, 2
    end
  end

  describe "#show" do
    it "successfully returns item show" do
      create_item(2)
      id = Item.first.id
      get :show, id: id, format: :json
      item = JSON.parse(response.body)

      assert_response :success
      assert_equal item["id"], id
    end
  end

      describe "#random" do
    it "successfully returns random item in database" do
      create_item(8)
      id_array = Item.pluck(:id)
      get :random, format: :json
      item1_id = JSON.parse(response.body)["id"]
      get :random, format: :json
      item2_id = JSON.parse(response.body)["id"]
   
      assert_response :success
      expect(id_array).to include(item1_id)
      expect(item1_id).not_to eq(item2_id)
    end
  end

  # describe "#create" do
  #   it "successfully creates an item" do
  #     assert_equal 0, Item.count

  #     item_params = { name: "Computer", description: "awesome computer" }
  #     post :create, item: item_params, format: :json
  #     item = Item.last

  #     assert_response :success
  #     assert_equal item.name, item_params[:name]
  #     assert_equal 1, Item.count
  #   end
  # end

  # describe "#update" do
  #   it "successfully updates an item" do
  #     create_item
  #     id = Item.first.id
  #     previous_name = Item.first.name
  #     item_params = { name: "NEW NAME" }

  #     put :update, id: id, item: item_params, format: :json
  #     item = Item.find_by(id: id)

  #     assert_response :success
  #     refute_equal previous_name, item.name
  #     assert_equal "NEW NAME", item.name
  #   end
  # end

  # describe "#destroy" do
  #   it "successfully deletes an item" do
  #     create_item
  #     assert_equal 1, Item.count 
  #     item = Item.last
  #     delete :destroy, id: item.id, format: :json

  #     assert_response :success
  #     refute Item.find_by(id: item.id)
  #     assert_equal 0, Item.count
  #   end
  # end

end