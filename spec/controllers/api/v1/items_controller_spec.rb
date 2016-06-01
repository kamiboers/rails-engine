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

  describe "#find" do
    it "returns item with id in search parameters" do
      create_item
      item = Item.first
      
      get :find, id: item.id

      assert_response :success
      expect(response.body).to include(item.name)
      expect(response.body).to include(item.description)
    end

    it "returns item with name in search parameters" do
      create_item
      item = Item.first

      get :find, name: item.name

      assert_response :success
      expect(response.body).to include(item.id.to_s)
  end

  it "returns item with description substring in search parameters" do
      create_item
      create_item(1, 1, "Described Item", "This item description like totes says stuff and things.")
      item = Item.last

      get :find, description: "totes"
      selected = JSON.parse(response.body)["item"]

      assert_response :success
      expect(selected["id"]).to eq(item.id)
      expect(selected["description"]).to include("totes")
  end 

  it "returns item with unit_price in search parameters" do
      create_item
      create_item(1, 1, "Priced Item", "Description", 432112)
      item = Item.last

      get :find, unit_price: 4321.12
      selected = JSON.parse(response.body)["item"]

      assert_response :success
      expect(selected["id"]).to eq(item.id)
      expect(selected["name"]).to eq("Priced Item")
  end

  it "returns item with merchant_id in search parameters" do
      create_item
      create_item(1, 87, "Merchant's Item", "Description", 10000)
      item = Item.last

      get :find, merchant_id: 87
      selected = JSON.parse(response.body)["item"]

      assert_response :success
      expect(selected["id"]).to eq(item.id)
      expect(selected["name"]).to eq("Merchant's Item")
  end
end

describe "#find_all" do
    it "returns all items with unit_price in search parameters" do
      create_item(1, 1, "name", "description", 12150)
      create_item(2, 1, "name", "description", 12275)
      
      get :find_all, unit_price: 122.75
      selected = JSON.parse(response.body)["items"]

      first_selected_price = selected.first["unit_price"]
      last_selected_price = selected.last["unit_price"]

      assert_response :success
      expect(selected.count).to eq(2)
      expect(first_selected_price).to eq(12275)
      expect(last_selected_price).to eq(12275)
    end

    it "returns all items with name in search parameters" do
      create_item(1, 1, "name", "description", 12275)
      create_item(2, 1, "Smelloscope", "description", 12275)
      
      get :find_all, name: "SmellOSCOPe"
      selected = JSON.parse(response.body)["items"]

      first_selected_name = selected.first["name"]
      last_selected_name = selected.last["name"]

      assert_response :success
      expect(selected.count).to eq(2)
      expect(first_selected_name).to eq("Smelloscope")
      expect(last_selected_name).to eq("Smelloscope")
    end

    it "returns all items containing description substring in search parameters" do
      create_item(1, 1, "name", "description", 10)
      create_item(2, 1, "name", "other description", 10)
      
      get :find_all, description: "description"
      selected = JSON.parse(response.body)["items"]
      first_selected_description = selected.first["description"]
      last_selected_description = selected.last["description"]

      assert_response :success
      expect(selected.count).to eq(3)
    end

    it "returns all items containing merchant_id in search parameters" do
      create_item(1, 11, "name", "description", 10)
      create_item(2, 99, "name", "other description", 10)
      
      get :find_all, merchant_id: 99
      selected = JSON.parse(response.body)["items"]
      first_selected_merchant_id = selected.first["merchant_id"]
      last_selected_merchant_id = selected.last["merchant_id"]

      assert_response :success
      expect(selected.count).to eq(2)
      expect(first_selected_merchant_id).to eq(99)
      expect(last_selected_merchant_id).to eq(99)
    end
end

 describe "#invoice_items" do
    it "successfully returns specific item invoice_item data" do
      create_item
      item = Item.last
      create_invoice_item(1, 6996, 9, item.id)
      create_invoice_item(1, 7447, 9, item.id)

      get :invoice_items, id: item.id
      item_invoice_items = JSON.parse(response.body)["invoice_items"]

      assert_response :success
      expect(item_invoice_items.count).to eq(2)
      expect(item_invoice_items.to_s).to include("6996")
      expect(item_invoice_items.to_s).to include("7447")
    end
  end

  describe "#merchant" do
    it "successfully returns specific item merchant data" do
      create_merchant(1, "T-Pain")
      merchant = Merchant.last
      create_item(1, merchant.id)
      item = Item.last

      get :merchant, id: item.id
      item_merchant = JSON.parse(response.body)["merchant"]

      assert_response :success
      expect(item_merchant.to_s).to include("T-Pain")
    end
  end

  describe "#most_revenue" do
    it "returns the top x most successful items" do
      fourth_ranked = create_item(1, 1, "Fourth Ranked")
      third_ranked = create_item(1, 1, "Third Ranked")
      second_ranked = create_item(1, 1, "Second Ranked")
      first_ranked = create_item(1, 1, "First Ranked")

      allow(fourth_ranked).to receive(:revenue).and_return(05)
      allow(third_ranked).to receive(:revenue).and_return(10)
      allow(second_ranked).to receive(:revenue).and_return(15)
      allow(first_ranked).to receive(:revenue).and_return(20)

      get :most_revenue, quantity: 3
      top_three = JSON.parse(response.body)["top_items"]


      expect(top_three.to_s).to include("First Ranked")
      expect(top_three.to_s).to include("Second Ranked")
      expect(top_three.to_s).to include("Third Ranked")
      expect(top_three.to_s).not_to include("Fourth Ranked")
    end
  end

  describe "#most_items" do
    it "returns the top x most successful items" do
      fourth_ranked = create_item(1, 1, "Fourth Ranked")
      third_ranked = create_item(1, 1, "Third Ranked")
      second_ranked = create_item(1, 1, "Second Ranked")
      first_ranked = create_item(1, 1, "First Ranked")

      allow(fourth_ranked).to receive(:number_sold).and_return(05)
      allow(third_ranked).to receive(:number_sold).and_return(10)
      allow(second_ranked).to receive(:number_sold).and_return(15)
      allow(first_ranked).to receive(:number_sold).and_return(20)

      get :most_items, quantity: 3
      top_three = JSON.parse(response.body)["top_items"]


      expect(top_three.to_s).to include("First Ranked")
      expect(top_three.to_s).to include("Second Ranked")
      expect(top_three.to_s).to include("Third Ranked")
      expect(top_three.to_s).not_to include("Fourth Ranked")
    end
  end

   describe "#best_day" do
    it "successfully returns specific item top sales day" do
      item = create_item
      invoice1 = create_invoice
      invoice2 = create_invoice
      date = Date.parse("07/07/07")

      invoice_item1 = create_invoice_item(1, item.unit_price, 1, item.id, invoice1.id)
      invoice_item2 = create_invoice_item(1, item.unit_price, 10, item.id, invoice2.id)
      invoice_item2.update(created_at: date, updated_at: date)
      create_transaction(1, "cc_number", "success", invoice1.id)
      create_transaction(1, "cc_number", "success", invoice2.id)

      get :best_day, id: item.id
      best_day = Date.parse(JSON.parse(response.body)["best_day"])

      assert_response :success
      expect(best_day).to eq(Date.parse("07/07/07"))
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