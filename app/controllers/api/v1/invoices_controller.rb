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
    render :json => {invoice: Invoice.search(params)}
  end

  def find_all
    render :json => {invoices: Invoice.search_all(params)}
  end

  def transactions
    invoice = Invoice.find(params[:id])
    render :json => {invoice: invoice, transactions: invoice.transactions}
  end

  def invoice_items
    invoice = Invoice.find(params[:id])
    render :json => {invoice: invoice, invoice_items: invoice.invoice_items}
  end

  def items
    invoice = Invoice.find(params[:id])
    render :json => {invoice: invoice, items: invoice.items}
  end

  def merchant
    invoice = Invoice.find(params[:id])
    render :json => {invoice: invoice, merchant: invoice.merchant}
  end

  def customer
    invoice = Invoice.find(params[:id])
    render :json => {invoice: invoice, customer: invoice.customer}
  end

  # def create
  #   respond_with Invoice.create(item_params), location: nil
  # end

  # def update
  #   respond_with Invoice.update(params[:id], item_params), location: nil
  # end

  # def destroy
  #   respond_with Invoice.delete(params[:id])
  # end

  # private

  # def item_params
  #   params.require(:invoice).permit(:id, :customer_id, :merchant_id, :status, :created_at, :updated_at)
  # end

end