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
    render :json => Item.search(params)
  end

  def find_all
    render :json => Item.search_all(params)
  end

  def invoice_items
    item = Item.find(params[:id])
    render :json => item.invoice_items
  end

  def merchant
    item = Item.find(params[:id])
    render :json => item.merchant
  end

  def most_revenue
    render :json => Item.top_by_revenue(params[:quantity])
  end

  def most_items
    render :json => Item.top_by_items_sold(params[:quantity])
  end

  def best_day
    item = Item.find(params[:id])
    render :json => { best_day: item.best_day }
  end

end