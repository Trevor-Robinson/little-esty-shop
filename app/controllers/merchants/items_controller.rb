class Merchants::ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update]

  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
  end

  def edit
  end

  def update
    if @item.update(item_params)
      flash[:notice] = "Item Succesfully Updated"
      redirect_to merchant_item_path(@item.merchant, @item)
    else
      flash[:notice] = "Required Information Missing"
      redirect_to edit_merchant_item_path(@item.merchant, @item)
    end
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price)
  end

  def set_item
    @item = Item.find(params[:id])
  end
end
