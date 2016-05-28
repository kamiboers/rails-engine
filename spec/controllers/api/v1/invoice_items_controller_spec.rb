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
      create_invoice_item(8)
      id_array = InvoiceItem.pluck(:id)
      get :random, format: :json
      invoice_item1_id = JSON.parse(response.body)["id"]
      get :random, format: :json
      invoice_item2_id = JSON.parse(response.body)["id"]
   
      assert_response :success
      expect(id_array).to include(invoice_item1_id)
      expect(invoice_item1_id).not_to eq(invoice_item2_id)
    end
  end
  # describe "#create" do
  #   it "successfully creates an invoice_item" do
  #     assert_equal 0, InvoiceItem.count

  #     invoice_item_params = { unit_price: 987.23 }
  #     post :create, invoice_item: invoice_item_params, format: :json
  #     invoice_item = InvoiceItem.last

  #     assert_response :success
  #     assert_equal invoice_item.unit_price, invoice_item_params[:unit_price]
  #     assert_equal 1, InvoiceItem.count
  #   end
  # end

  # describe "#update" do
  #   it "successfully updates an invoice_item" do
  #     create_invoice_item
  #     id = InvoiceItem.first.id
  #     previous_unit_price = InvoiceItem.first.unit_price
  #     invoice_item_params = { unit_price: 18.23 }

  #     put :update, id: id, invoice_item: invoice_item_params, format: :json
  #     invoice_item = InvoiceItem.find_by(id: id)

  #     assert_response :success
  #     refute_equal previous_unit_price, invoice_item.unit_price
  #     assert_equal 18.23, invoice_item.unit_price
  #   end
  # end

  # describe "#destroy" do
  #   it "successfully deletes an invoice_item" do
  #     create_invoice_item
  #     assert_equal 1, InvoiceItem.count 
  #     invoice_item = InvoiceItem.last
  #     delete :destroy, id: invoice_item.id, format: :json

  #     assert_response :success
  #     refute InvoiceItem.find_by(id: invoice_item.id)
  #     assert_equal 0, InvoiceItem.count
  #   end
  # end

end