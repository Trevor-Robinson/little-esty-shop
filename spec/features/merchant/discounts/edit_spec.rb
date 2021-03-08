require "rails_helper"

RSpec.describe "When I visit '/merchant/merchant_id/discount/discount_id/edit'" do
  before :each do
    @merchant1 = create(:merchant)

    @discount1 = create(:discount, quantity: 10, percentage: 15, merchant_id: @merchant1.id)
    @discount2 = create(:discount, quantity: 20, percentage: 30, merchant_id: @merchant1.id)
  end

  it "can be reached from show page" do
    visit merchant_discount_path(@merchant1, @discount1)

    click_link("Edit Bulk Discount")

    expect(current_path).to eq(edit_merchant_discount_path(@merchant1, @discount1))
  end
  it "can edit information" do
    visit  edit_merchant_discount_path(@merchant1, @discount1)

      fill_in 'percentage', with: 25
      fill_in 'quantity', with: 20
      click_on 'Update Bulk Discount'

      expect(current_path).to eq(merchant_discount_path(@merchant1, @discount1))
      expect(page).to have_content(25)
      expect(page).to have_content(20)
      expect(page).to_not have_content(10)
      expect(page).to_not have_content(15)
  end

  it "will not submit without percentage and quantity filled out" do
    visit  edit_merchant_discount_path(@merchant1, @discount1)

      fill_in 'percentage', with: ''
      fill_in 'quantity', with: 20
      click_on 'Update Bulk Discount'

      expect(page).to have_content("Required Information Missing")
  end

end
