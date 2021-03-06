require 'rails_helper'

RSpec.describe Api::V1::InvoiceItemsController, type: :controller do
  describe "#index" do
    it "successfully returns invoice_items index" do
      create_invoice_item(2)
      get :index, format: :json
      invoice_items = JSON.parse(response.body)

      assert_response :success
      assert_equal invoice_items.count, 2
    end
  end

  describe "#show" do
    it "successfully returns invoice_item show" do
      create_invoice_item(2)
      id = InvoiceItem.first.id
      get :show, id: id, format: :json
      invoice_item = JSON.parse(response.body)

      assert_response :success
      assert_equal invoice_item["id"], id
    end
  end

  describe "#random" do
    it "successfully returns random invoice_item in database" do
      create_invoice_item(10)
      id_array = InvoiceItem.pluck(:id)
      get :random, format: :json
      id1 = JSON.parse(response.body)["id"]
      get :random, format: :json
      id2 = JSON.parse(response.body)["id"]
      get :random, format: :json
      id3 = JSON.parse(response.body)["id"]
      unique_results = [id1, id2, id3].uniq.count

      assert_response :success
      expect(id_array).to include(id1)
      expect(id_array).to include(id2)
      expect(id_array).to include(id3)
      expect(unique_results).not_to eq(1)
    end
  end


  describe "#find" do
    it "returns invoice_item with id in search parameters" do
      invoice_item = create_invoice_item
      get :find, id: invoice_item.id

      assert_response :success
      expect(response.body).to include(invoice_item.id.to_s)
      expect(response.body).to include(invoice_item.quantity.to_s)
      expect(response.body).to include((invoice_item.unit_price/100.0).to_s)
    end

    it "returns invoice_item with credit_card_number in search parameters" do
      invoice_item = create_invoice_item

      get :find, invoice_id: invoice_item.invoice_id

      assert_response :success
      expect(response.body).to include(invoice_item.id.to_s)
    end

    it "returns invoice_item with unit_price in search parameters" do
      invoice_item = create_invoice_item(1, 12345)
      get :find, unit_price: 123.45

      assert_response :success
      expect(response.body).to include(invoice_item.id.to_s)
    end

    it "returns invoice_item with created_at in search parameters" do
      invoice_item = create_invoice_item(1, 77777777)
      date = "12/12/12".to_datetime
      invoice_item.update!(created_at: date)

      get :find, created_at: date

      assert_response :success
      expect(response.body).to include(invoice_item.id.to_s)
      expect(response.body).to include("777777.77")
    end

    it "returns invoice_item with updated_at in search parameters" do
      invoice_item = create_invoice_item(1, 77777777)
      date = "12/12/12".to_datetime
      invoice_item.update!(updated_at: date)

      get :find, updated_at: date

      assert_response :success
      expect(response.body).to include(invoice_item.id.to_s)
      expect(response.body).to include("777777.77")
    end

  end

  describe "#find_all" do
    it "returns all invoice_items with unit_price in search parameters" do
      create_invoice_item(1, 1250)
      create_invoice_item(2, 1275)

      get :find_all, unit_price: 12.75
      selected = JSON.parse(response.body)

      first_selected_price = selected.first["unit_price"]
      last_selected_price = selected.last["unit_price"]

      assert_response :success
      expect(selected.count).to eq(2)
      expect(first_selected_price).to eq(12.75.to_s)
      expect(last_selected_price).to eq(12.75.to_s)
    end

    it "returns all invoice_items with quantity in search parameters regardless of case" do
      create_invoice_item(1, 12.50, 3)
      create_invoice_item(2, 12.50, 16)

      get :find_all, quantity: 16
      selected = JSON.parse(response.body)

      assert_response :success
      expect(selected.count).to eq(2)
      expect(selected.first["quantity"]).to eq(16)
      expect(selected.last["quantity"]).to eq(16)
    end

    it "returns all invoice_items with item_id in search parameters regardless of case" do
      create_invoice_item(1, 12.50, 3, 5)
      create_invoice_item(2, 12.50, 3, 17)

      get :find_all, item_id: 17
      selected = JSON.parse(response.body)

      assert_response :success
      expect(selected.count).to eq(2)
      expect(selected.first["item_id"]).to eq(17)
      expect(selected.last["item_id"]).to eq(17)
    end

    it "returns all invoice_items with invoice_id in search parameters regardless of case" do
      create_invoice_item(1, 12.50, 3, 5, 8)
      create_invoice_item(2, 12.50, 3, 5, 99)

      get :find_all, invoice_id: 99
      selected = JSON.parse(response.body)

      assert_response :success
      expect(selected.count).to eq(2)
      expect(selected.first["invoice_id"]).to eq(99)
      expect(selected.last["invoice_id"]).to eq(99)
    end

    it "returns all invoice_items with created_at in search parameters" do
      invoice_item1 = create_invoice_item(1, 333333)
      invoice_item2 = create_invoice_item(1, 444444)
      invoice_item3 = create_invoice_item(1, 555555)

      date = "12/12/12".to_datetime
      invoice_item1.update!(created_at: date)
      invoice_item2.update!(created_at: date)

      get :find_all, created_at: date
      results = JSON.parse(response.body)

      assert_response :success
      expect(results.count).to eq(2)
      expect(results.to_s).to include("3333.33")
      expect(results.to_s).to include("4444.44")
      expect(results.to_s).not_to include("5555.55")
    end

    it "returns all invoice_items with updated_at in search parameters" do
      invoice_item1 = create_invoice_item(1, 333333)
      invoice_item2 = create_invoice_item(1, 444444)
      invoice_item3 = create_invoice_item(1, 555555)

      date = "12/12/12".to_datetime
      invoice_item1.update!(updated_at: date)
      invoice_item2.update!(updated_at: date)

      get :find_all, updated_at: date
      results = JSON.parse(response.body)

      assert_response :success
      expect(results.count).to eq(2)
      expect(results.to_s).to include("3333.33")
      expect(results.to_s).to include("4444.44")
      expect(results.to_s).not_to include("5555.55")
    end
  end

  describe "#invoice" do
    it "successfully returns invoice item's invoice data" do
      invoice = create_invoice(1, "arbitrary status")
      invoice_item = create_invoice_item(1, 10.99, 2, 3, invoice.id)

      get :invoice, id: invoice_item.id
      invoice_item_invoice = JSON.parse(response.body)

      assert_response :success
      expect(invoice_item_invoice.to_s).to include("arbitrary status")
    end
  end
  
  describe "#item" do
    it "successfully returns invoice item's item data" do
      item = create_item(1, 1, "II's Item")
      invoice_item = create_invoice_item(1, 10.99, 2, item.id, 1)

      get :item, id: invoice_item.id
      invoice_item_item = JSON.parse(response.body)

      assert_response :success
      expect(invoice_item_item.to_s).to include("II's Item")
    end
  end
end