class Api::V1::InvoiceItemsController < ApplicationController
  respond_to :json

  def index
    respond_with InvoiceItem.all
  end

  def show
    respond_with InvoiceItem.find(params[:id])
  end

  def random
    respond_with InvoiceItem.random
  end

  def find
    render :json => {invoice_item: InvoiceItem.search(params)}
  end

  def find_all
    render :json => {invoice_items: InvoiceItem.search_all(params)}
  end

  def invoice
    invoice_item = InvoiceItem.find(params[:id])
    render :json => {invoice_item: invoice_item, invoice: invoice_item.invoice}
  end

  def item
    invoice_item = InvoiceItem.find(params[:id])
    render :json => {invoice_item: invoice_item, item: invoice_item.item}
  end

  # def create
  #   respond_with InvoiceItem.create(item_params), location: nil
  # end

  # def update
  #   respond_with InvoiceItem.update(params[:id], item_params), location: nil
  # end

  # def destroy
  #   respond_with InvoiceItem.delete(params[:id])
  # end

  # private

  # def item_params
  #   params.require(:invoice_item).permit(:id, :item_id, :invoice_id, :quantity, :unit_price, :created_at, :updated_at)
  # end

end