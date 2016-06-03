class Api::V1::InvoicesController < ApplicationController
  respond_to :json

  def index
    respond_with Invoice.all
  end

  def show
    respond_with Invoice.find(params[:id])
  end

  def random
    respond_with Invoice.random
  end

  def find
    render :json => Invoice.search(params)
  end

  def find_all
    render :json => Invoice.search_all(params)
  end

  def transactions
    invoice = Invoice.find(params[:id])
    render :json => invoice.transactions
  end

  def invoice_items
    invoice = Invoice.find(params[:id])
    render :json => invoice.invoice_items
  end

  def items
    invoice = Invoice.find(params[:id])
    render :json => invoice.items
  end

  def merchant
    invoice = Invoice.find(params[:id])
    render :json => invoice.merchant
  end

  def customer
    invoice = Invoice.find(params[:id])
    render :json => invoice.customer
  end

end