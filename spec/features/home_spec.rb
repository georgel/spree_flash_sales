require 'spec_helper'

feature "Home" do
  background do
    create_list(:flash_sale, 3)

    visit spree.root_path
  end

  scenario "displays a notice if there's no active flash sales" do
    expect(page).to have_content "There are no active sales at the moment. Check back soon!"
  end

  scenario "shows a list of live flash sales" do
    expect(page).to have_css(".flash_sale", count: 3)
  end

end

feature "home: don't list inactive flash sales" do
  given!(:inactive_flash_sale) { create(:inactive_flash_sale) }

  scenario "does not list inactive flash sales" do
    inactive_flash_sale
    visit spree.root_path
    expect(page).to_not have_content(inactive_flash_sale.name)
  end
end

feature 'home: flash sale for product' do
  given!(:flash_sale) { create(:flash_sale_for_product) }

  scenario "clicking flash sale" do
    visit spree.root_path
    find_link(flash_sale.name).click
    current_path.should == spree.product_path(flash_sale.saleable) # should go to the product directly
  end
end

feature 'home: flash sale for taxon' do
  given!(:flash_sale) { create(:flash_sale) }

  scenario "takes you to flash sale page" do
    visit spree.root_path
    find_link(flash_sale.name).click
    current_path.should == spree.flash_sale_path(flash_sale)
  end
end

feature 'home: showing time left on a flash sale' do
  given!(:flash_sale) { create(:flash_sale) }

  scenario "shows time left" do
    visit spree.root_path
    find("#flash_sale_#{flash_sale.id}").should have_css(".flash-sale-countdown")
  end
end
