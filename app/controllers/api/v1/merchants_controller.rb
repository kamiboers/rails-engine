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
    render :json => Merchant.search(params)
  end

  def find_all
    render :json => Merchant.search_all(params)
  end

  def items
    merchant = Merchant.find(params[:id])
    render :json => merchant.items
  end

  def invoices
    merchant = Merchant.find(params[:id])
    render :json => merchant.invoices
  end

  def most_revenue
    render :json => Merchant.top_by_revenue(params[:quantity])
  end
 
  def most_items
    render :json => Merchant.top_by_item_count(params[:quantity])
  end

  def all_revenue
    render :json => {total_revenue: (Merchant.revenue_by_date(params[:date]).to_s)}
  end

  def revenue
    merchant = Merchant.find(params[:id])
    if params[:date] 
      render :json => {revenue: (merchant.revenue_by_date(params[:date]).to_s)}
    else
      render :json => {revenue: merchant.sales.to_s}
    end
  end

  def favorite_customer
    merchant = Merchant.find(params[:id])
    render :json => merchant.favorite_customer
  end

  def customers_with_pending_invoices
    merchant = Merchant.find(params[:id])
    render :json => merchant.customers_with_pending_invoices
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