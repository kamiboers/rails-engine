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
    render :json => InvoiceItem.search(params)
  end

  def find_all
    render :json => InvoiceItem.search_all(params)
  end

  def invoice
    invoice_item = InvoiceItem.find(params[:id])
    render :json => invoice_item.invoice
  end

  def item
    invoice_item = InvoiceItem.find(params[:id])
    render :json => invoice_item.item
  end
  
end