class Api::V1::CustomersController < ApplicationController
  respond_to :json

  def index
    respond_with Customer.all
  end

  def show
    respond_with Customer.find(params[:id])
  end

  def random
    respond_with Customer.random
  end

  def find
    render :json => Customer.search(params)
  end

  def find_all
    render :json => Customer.search_all(params)
  end

  def invoices
    customer = Customer.find(params[:id])
    render :json => customer.invoices
  end

  def transactions
    customer = Customer.find(params[:id])
    render :json => customer.transactions
  end

  def favorite_merchant
    customer = Customer.find(params[:id])
    render :json => customer.favorite_merchant
  end

end