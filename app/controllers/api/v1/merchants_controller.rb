class Api::V1::MerchantsController < ApplicationController
  respond_to :json

  def index
    respond_with Merchant.all
  end

  def show
    respond_with Merchant.find(params[:id])
  end

  def random
    respond_with Merchant.random
  end

  def find
    render :json => { merchant: Merchant.search(params) }
  end

  def find_all
    render :json => { merchants: Merchant.search_all(params) }
  end

  def items
    merchant = Merchant.find(params[:id])
    render :json => { merchant: merchant, items: merchant.items }
  end

  def invoices
    merchant = Merchant.find(params[:id])
    render :json => { merchant: merchant, invoices: merchant.invoices }
  end
 

  # def create
  #   respond_with Merchant.create(item_params), location: nil
  # end

  # def update
  #   respond_with Merchant.update(params[:id], item_params), location: nil
  # end

  # def destroy
  #   respond_with Merchant.delete(params[:id])
  # end

  # private

  # def item_params
  #   params.require(:merchant).permit(:id, :name, :created_at, :updated_at)
  # end

end