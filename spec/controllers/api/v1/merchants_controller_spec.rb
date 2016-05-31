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
      create_merchant(1, "Nick")
      merchant = Merchant.last
      get :find, name: "Nick"

      assert_response :success
      expect(response.body).to include(merchant.id.to_s)
    end
  end

  describe "#find_all" do
    it "returns all merchants with name in search parameters" do
      create_merchant(1, "John McJohn")
      create_merchant(2, "Steve McSteve")
      
      get :find_all, name: "Steve McSteve"
      selected = JSON.parse(response.body)["merchants"]

      first_selected_name = selected.first["name"]
      last_selected_name = selected.last["name"]

      assert_response :success
      expect(selected.count).to eq(2)
      expect(first_selected_name).to eq("Steve McSteve")
      expect(last_selected_name).to eq("Steve McSteve")
    end

    it "returns all merchants with name in search parameters regardless of case" do
      create_merchant(1, "Steve")
      create_merchant(1, "sTEVe")
      create_merchant(1, "Blue")

      get :find_all, name: "steve"
      selected = JSON.parse(response.body)["merchants"]
      
      assert_response :success
      expect(selected.count).to eq(2)
    end
  end

  describe "#items" do
    it "successfully returns specific merchant item data" do
      create_merchant(2)
      merchant = Merchant.last
      create_item
      create_item(2, merchant.id, "Merchant ##{merchant.id}'s Item")
      item = Item.last
      
      get :items, id: merchant.id

      merchant_items = JSON.parse(response.body)["items"]

      assert_response :success
      expect(merchant_items.count).to eq(2)
      expect(merchant_items.last["name"]).to eq("Merchant ##{merchant.id}'s Item")
    end
  end

  describe "#invoices" do
    it "successfully returns specific merchant invoice data" do
      create_merchant(2)
      merchant = Merchant.last
      create_invoice
      create_invoice(2, "paid", 1, merchant.id)
      invoice = Invoice.last
      
      get :invoices, id: merchant.id

      merchant_invoices = JSON.parse(response.body)["invoices"]

      assert_response :success
      expect(merchant_invoices.count).to eq(2)
      expect(merchant_invoices.last["id"]).to eq(invoice.id)
    end
  end

  describe "#most_revenue" do
    it "successfully returns top x merchants by revenue" do
      fourth_ranked = create_merchant(1, "Fourth Ranked")
      third_ranked = create_merchant(1, "Third Ranked")
      second_ranked = create_merchant(1, "Second Ranked")
      first_ranked = create_merchant(1, "First Ranked")

      allow(fourth_ranked).to receive(:sales).and_return(05)
      allow(third_ranked).to receive(:sales).and_return(10)
      allow(second_ranked).to receive(:sales).and_return(15)
      allow(first_ranked).to receive(:sales).and_return(20)

      get :most_revenue, quantity: 3
      top_three = JSON.parse(response.body)["top_merchants"]

      expect(top_three.to_s).to include("First Ranked")
      expect(top_three.to_s).to include("Second Ranked")
      expect(top_three.to_s).to include("Third Ranked")
      expect(top_three.to_s).not_to include("Fourth Ranked")
    end
  end

  describe "#most_items" do
    it "returns top merchants by number of items" do
      fourth_ranked = create_merchant(1, "Fourth Ranked")
      third_ranked = create_merchant(1, "Third Ranked")
      second_ranked = create_merchant(1, "Second Ranked")
      first_ranked = create_merchant(1, "First Ranked")

      allow(fourth_ranked).to receive(:item_count).and_return(05)
      allow(third_ranked).to receive(:item_count).and_return(10)
      allow(second_ranked).to receive(:item_count).and_return(15)
      allow(first_ranked).to receive(:item_count).and_return(20)
      
      get :most_items, quantity: 3
      top_three = JSON.parse(response.body)["top_merchants"]


      expect(top_three.to_s).to include("First Ranked")
      expect(top_three.to_s).to include("Second Ranked")
      expect(top_three.to_s).to include("Third Ranked")
      expect(top_three.to_s).not_to include("Fourth Ranked")
    end
  end

  describe "#revenue_by_date"
  it "returns all merchants' revenue by date of transaction" do
    create_merchant(2)
    merchant1 = Merchant.first
    merchant2 = Merchant.last
    create_invoice(1, "shipped", 1, merchant1.id)
    invoice1 = Invoice.last
    create_invoice_item(1, 20, 20, 1, invoice1.id)
    create_transaction(1, "cc_number", "success", invoice1.id)  

    create_invoice(1, "shipped", 1, merchant2.id)
    invoice2 = Invoice.last
    create_invoice_item(1, 30, 30, 1, invoice2.id)
    create_transaction(1, "cc_number", "success", invoice2.id)

    today = (Date.today).strftime("%m/%d/%Y")
    yesterday = (Date.yesterday).strftime("%m/%d/%Y")

    get :revenue, date: today
    revenue_today = JSON.parse(response.body)["date_revenue"]
    get :revenue, date: yesterday
    revenue_yesterday = JSON.parse(response.body)["date_revenue"]

    expect(revenue_today.to_f).to eq(1300)
    expect(revenue_yesterday.to_f).to eq(0)
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