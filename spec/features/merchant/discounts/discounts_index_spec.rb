require "rails_helper"

RSpec.describe "When I visit '/merchant/merchant_id/dashboard'" do
  before :each do
    @merchant1 = create(:merchant)

    @discount1 = create(:discount, quantity: 10, percentage: 15, merchant_id: @merchant1.id)
    @discount2 = create(:discount, quantity: 20, percentage: 30, merchant_id: @merchant1.id)

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

  it 'shows all discounts for the merchant as links' do
    VCR.use_cassette('nager_service_content') do
      visit merchant_discounts_path(@merchant1)

      expect(page).to have_content(@discount1.quantity)
      expect(page).to have_content(@discount1.percentage)
      expect(page).to have_link("#{@discount1.percentage}% off of #{@discount1.quantity}")
      expect(page).to have_link("#{@discount2.percentage}% off of #{@discount2.quantity}")
    end
  end

  it "can click discount link to go to discount show page" do
    VCR.use_cassette('nager_service_content') do
      visit merchant_discounts_path(@merchant1)
      click_link("#{@discount1.percentage}% off of #{@discount1.quantity}")
      expect(current_path).to eq(merchant_discount_path(@merchant1, @discount1))
    end
  end

  it 'shows the next three upcoming us holidays' do
    VCR.use_cassette('nager_service_content') do
      service = NagerService.new
      holidays = service.holiday_list
      visit merchant_discounts_path(@merchant1)
      expect(page).to have_content(holidays[0].date)
      expect(page).to have_content(holidays[1].date)
      expect(page).to have_content(holidays[2].date)
      expect(page).to have_content(holidays[0].name)
      expect(page).to have_content(holidays[1].name)
      expect(page).to have_content(holidays[2].name)
    end
  end

  it 'has a link to create new discount' do
    VCR.use_cassette('nager_service_content') do
      visit merchant_discounts_path(@merchant1)

      expect(page).to have_link("New Bulk Discount")
    end
  end

  it 'has delete button for each discount' do
    VCR.use_cassette('nager_service_content') do
      visit merchant_discounts_path(@merchant1)

      within("#discount-#{@discount1.id}") do
        expect(page).to have_link("Delete")
      end
      within("#discount-#{@discount2.id}") do
        expect(page).to have_link("Delete")
      end
    end
  end
  it 'deletes discount when delete is clicked' do
    VCR.use_cassette('nager_service_content') do
      visit merchant_discounts_path(@merchant1)

      expect(page).to have_link("#{@discount1.percentage}% off of #{@discount1.quantity}")
      expect(page).to have_link("#{@discount2.percentage}% off of #{@discount2.quantity}")

      within("#discount-#{@discount1.id}") do
        click_link("Delete")
      end
      within("#discount-#{@discount2.id}") do
        expect(page).to have_link("Delete")
      end
      expect(page).to_not have_link("#{@discount1.percentage}% off of #{@discount1.quantity}")
      expect(page).to have_link("#{@discount2.percentage}% off of #{@discount2.quantity}")
    end
  end
end
