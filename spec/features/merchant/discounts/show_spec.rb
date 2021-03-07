require "rails_helper"

RSpec.describe "When I visit '/merchant/merchant_id/dashboard'" do
  before :each do
    @merchant1 = create(:merchant)

    @discount1 = create(:discount, quantity: 10, percentage: 15, merchant_id: @merchant1.id)
  end

  it "shows discount's percentage and quantity" do
    visit merchant_discount_path(@merchant1, @discount1)
    expect(page).to have_content(@discount1.quantity)
    expect(page).to have_content(@discount1.percentage)
  end

  it "has a link to edit the discount" do
    visit merchant_discount_path(@merchant1, @discount1)

    expect(page).to have_link("Edit Bulk Discount")
  end
end
