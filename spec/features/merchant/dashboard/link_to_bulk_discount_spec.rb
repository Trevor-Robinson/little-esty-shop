require "rails_helper"

RSpec.describe "When I visit '/merchant/merchant_id/dashboard'" do
  before :each do
    @merchant1 = create(:merchant)

    @item = create(:item, merchant_id: @merchant1.id)
    @item2 = create(:item, merchant_id: @merchant1.id)
    @item3 = create(:item, merchant_id: @merchant1.id)
    @item4 = create(:item, merchant_id: @merchant1.id)
    @item5 = create(:item, merchant_id: @merchant1.id)
    @item6 = create(:item, merchant_id: @merchant1.id)

    @invoice = create(:invoice, created_at: "2013-03-25 09:54:09 UTC")
    @invoice2 = create(:invoice, created_at: "2012-03-17 09:54:09 UTC")
    @invoice3 = create(:invoice, created_at: "2011-03-01 09:54:09 UTC")
    @invoice4 = create(:invoice, created_at: "2020-03-25 09:54:09 UTC")

    @invoice_item = create(:invoice_item, invoice_id: @invoice.id, item_id: @item.id, status: 0)
    @invoice_item2 = create(:invoice_item, invoice_id: @invoice2.id, item_id: @item2.id, status: 1)
    @invoice_item3 = create(:invoice_item, invoice_id: @invoice3.id, item_id: @item3.id, status: 1)
    @invoice_item4 = create(:invoice_item, invoice_id: @invoice4.id, item_id: @item4.id, status: 0)
    @invoice_item5 = create(:invoice_item_with_invoices, item_id: @item5.id, status: 2)
    @invoice_item6 = create(:invoice_item_with_invoices, item_id: @item6.id, status: 2)
  end

  it "displays a link to merchant's bulk discount index" do
    visit merchant_dashboard_index_path(@merchant1)

    expect(page).to have_link("#{@merchant1.name}'s Discounts Index")
  end

  it "can click link to go to merchant's bulk discount index" do
    visit merchant_dashboard_index_path(@merchant1)
    click_link("#{@merchant1.name}'s Discounts Index")
    expect(current_path).to eq(merchant_discounts_path(@merchant1))
  end
end
