class Api::V1::MerchantsController < ApplicationController
  respond_to :json

  def index
    respond_with Merchant.all
  end

  def show
    respond_with Merchant.find(params[:id])
  end

  def random
    respond_with Merchant.offset(rand(Merchant.count)).first
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

  private

  def item_params
    params.require(:merchant).permit(:id, :name, :created_at, :updated_at)
  end

end