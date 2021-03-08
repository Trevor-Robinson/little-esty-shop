require "rails_helper"

RSpec.describe "When I visit '/merchant/merchant_id/discount/new'" do
  before :each do
    @merchant1 = create(:merchant)
  end
  it "can create a new bulk discount" do
    VCR.use_cassette('nager_service_content') do
      visit new_merchant_discount_path(@merchant1)

      fill_in 'percentage', with: 25
      fill_in 'quantity', with: 20
      click_button "Create Bulk Discount"

      expect(current_path).to eq(merchant_discounts_path(@merchant1))
      expect(page).to have_content("25% off of 20")
    end
  end
  it "won't create bulk discount without percentage and quantity" do
    visit new_merchant_discount_path(@merchant1)
    fill_in 'percentage', with: ''
    fill_in 'quantity', with: 20
    click_button "Create Bulk Discount"
    expect(current_path).to eq(merchant_discounts_path(@merchant1))
    expect(page).to have_content("Required Information Missing")
  end

end
