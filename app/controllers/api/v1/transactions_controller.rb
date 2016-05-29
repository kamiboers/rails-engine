class Api::V1::TransactionsController < ApplicationController
  respond_to :json

  def index
    respond_with Transaction.all
  end

  def show
    respond_with Transaction.find(params[:id])
  end

  def random
    respond_with Transaction.random
  end

  def find
    render :json => {transaction: Transaction.search(params)}
  end

  def find_all
    render :json => {transactions: Transaction.search_all(params)}
  end
 
  # def create
  #   respond_with Transaction.create(item_params), location: nil
  # end

  # def update
  #   respond_with Transaction.update(params[:id], item_params), location: nil
  # end

  # def destroy
  #   respond_with Transaction.delete(params[:id])
  # end

  # private

  # def item_params
  #   params.require(:transaction).permit(:id, :invoice_id, :cc_number, :expiration, :result, :created_at, :updated_at)
  # end

end