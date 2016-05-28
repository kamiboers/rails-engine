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

  # def create
  #   respond_with Customer.create(item_params), location: nil
  # end

  # def update
  #   respond_with Customer.update(params[:id], item_params), location: nil
  # end

  # def destroy
  #   respond_with Customer.delete(params[:id])
  # end

  private

  def item_params
    params.require(:customer).permit(:id, :first_name, :last_name, :created_at, :updated_at)
  end

end