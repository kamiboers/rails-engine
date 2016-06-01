class Api::V1::ItemsController < ApplicationController
  respond_to :json

  def index
    respond_with Item.all
  end

  def show
    respond_with Item.find(params[:id])
  end

  def random
    respond_with Item.random
  end

  def find
    render :json => {item: Item.search(params)}
  end

  def find_all
    render :json => {items: Item.search_all(params)}
  end

  def invoice_items
    item = Item.find(params[:id])
    render :json => {item: item, invoice_items: item.invoice_items}
  end

  def merchant
    item = Item.find(params[:id])
    render :json => {item: item, merchant: item.merchant}
  end

  def most_revenue
    render :json => {top_items: Item.top_by_revenue(params[:quantity])}
  end

  def most_items
    render :json => {top_items: Item.top_by_items_sold(params[:quantity])}
  end


  # def create
  #   respond_with Item.create(item_params), location: nil
  # end

  # def update
  #   respond_with Item.update(params[:id], item_params), location: nil
  # end

  # def destroy
  #   respond_with Item.delete(params[:id])
  # end

  # private

  # def item_params
  #   params.require(:item).permit(:id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at)
  # end

end