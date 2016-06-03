class Api::V1::TransactionsController < ApplicationController
  respond_to :json

  def index
    respond_with Transaction.all
  end

  def show
    respond_with Transaction.find_by(id: params[:id])
  end

  def random
    respond_with Transaction.random
  end

  def find
    render :json => Transaction.search(params)
  end

  def find_all
    render :json => Transaction.search_all(params)
  end

  def invoice
    transaction = Transaction.find(params[:id])
    render :json => transaction.invoice
  end

end