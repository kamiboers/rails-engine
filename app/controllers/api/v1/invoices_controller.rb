class Api::V1::InvoicesController < ApplicationController
  respond_to :json

  def index
    respond_with Invoice.all
  end

  def show
    respond_with Invoice.find(params[:id])
  end

  def random
    respond_with Invoice.offset(rand(Invoice.count)).first
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

  private

  def item_params
    params.require(:invoice).permit(:id, :customer_id, :merchant_id, :status, :created_at, :updated_at)
  end

end