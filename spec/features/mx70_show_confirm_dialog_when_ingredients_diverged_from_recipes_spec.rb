require 'rails_helper'

RSpec.shared_examples "displays a confirmation modal" do

  it 'displays a confirmation modal' do
    expect(page.find('#confirmModal')).to have_text('Confirmation Required')
  end

end

RSpec.shared_examples "does not display a confirmation modal" do

  it 'does not display a confirmation modal' do
    expect(page).not_to have_text('Confirmation Required')
  end

end

RSpec.feature "MX70 Show Confirm Dialog When Ingredients Diverged From Recipes", type: :feature, js: true do

  let!(:consumable_type) { create(:consumable_type_with_recipe) }
  let!(:another_consumable_type) { create(:consumable_type) }
  let!(:another_supplier) { create(:supplier) }
  let!(:another_unit) { create(:unit) }

  before(:each) do
    sign_in
    visit new_batch_path
    select consumable_type.name, from: 'Consumable Type'
    edit_ingredients
    click_button "Create Batch"
  end

  context 'after adding a row to Ingredients' do
    let(:edit_ingredients) { click_button 'Add Ingredient' }
    include_examples "displays a confirmation modal"
  end

  context 'after deleting a row from Ingredients' do
    let(:edit_ingredients) { all(:data_behavior, "remove_row").first.click }
    include_examples "displays a confirmation modal"
  end

  context 'after editing Consumable Type in ingredients' do
    let(:edit_ingredients) do
      all(:xpath, '//select[@name="mixable[mixture_criteria][][consumable_type_id]"]')
        .first.select(another_consumable_type.name)
    end
    include_examples "displays a confirmation modal"
  end

  context 'after editing Lot/Batch number in ingredients' do
    let(:edit_ingredients) do
      page.all('input[name*="number"]')
        .first.set('different number')
    end
    include_examples "does not display a confirmation modal"
  end

  context 'after editing Supplier in ingredients' do
    let(:edit_ingredients) do
      all(:xpath, '//select[@name="mixable[mixture_criteria][][kitchen_id]"]')
        .first.select(another_supplier.name)
    end
    include_examples "displays a confirmation modal"
  end

  context 'after editing Quantity in ingredients' do
    let(:edit_ingredients) do
      page.all('input[name*="quantity"]')
        .first.set(1234)
    end
    include_examples "displays a confirmation modal"
  end

  context 'after editing Supplier in ingredients' do
    let(:edit_ingredients) do
      all(:xpath, '//select[@name="mixable[mixture_criteria][][unit_id]"]')
        .first.select(another_unit.name)
    end
    include_examples "displays a confirmation modal"
  end

end
