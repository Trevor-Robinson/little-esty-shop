class Merchants::DiscountsController < ApplicationController
  before_action :set_discount, only: [:show, :edit, :update]
  before_action :set_merchant, only: [:index, :new, :create, :show]
  def index
    @holidays = service.holiday_list
  end

  def show
  end

  def new
    @discount = Discount.new
  end

  def create
    @discount = @merchant.discounts.new(discount_params)
    if @discount.save
      flash[:notice] = "Bulk Discount Created"
      redirect_to merchant_discounts_path(@merchant)
    else
      flash[:notice] = "Required Information Missing"
      render :new
    end
  end

  def destroy
    Discount.destroy(params[:id])
    redirect_to merchant_discounts_path(params[:merchant_id])
  end

  private
  def service
    NagerService.new
  end

  def discount_params
    params.permit(:percentage, :quantity)
  end

  def set_discount
    @discount = Discount.find(params[:id])
  end

  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
