require "rails_helper"

RSpec.describe "ConsumableTypes", type: :feature, js: true do

  let! (:consumable_type) { build(:consumable_type) }
  let! (:consumable_types) { create_list(:consumable_type, 3) }
  let! (:saved_consumable_type) { create(:consumable_type) }
  let! (:suppliers) { create_list(:supplier, 3) }
  let! (:units) { create_list(:unit, 3) }

  let(:fill_in_form) {
    visit consumable_types_path
    click_link "New consumable type"

    fill_in "Name*", with: consumable_type.name
    fill_in "Days to Keep", with: consumable_type.days_to_keep
    select consumable_type.storage_condition, from: "Storage condition"
  }

  let(:submit_form) { click_button "Create Consumable type" }

  before(:each) do
    sign_in
  end

  describe '#new' do
    let(:create_a_consumable_type) do
      fill_in_form
      submit_form
    end

    it "Allows a user to create a new consumable type" do
      expect { create_a_consumable_type }.to change(ConsumableType, :count).by(1)
      expect(page).to have_content("Consumable Type successfully created")
    end

    it "Creates a new audit record", js: true do
      expect { create_a_consumable_type }.to change(Audit, :count).by(1)
    end

    it "Reports an error if a user adds a consumable type with invalid attributes" do

      consumable_type = create(:consumable_type)

      visit new_consumable_type_path
      expect {
        fill_in "Name", with: consumable_type.name
        click_button "Create Consumable type"
      }.to_not change(ConsumableType, :count)
      expect(page).to have_content("error prohibited this record from being saved")
    end

    describe 'with ingredients' do
      let(:fill_in_ingredients) do
        click_button 'Add Ingredient'
        select consumable_types.first.name, from: "mixable[mixture_criteria][][consumable_type_id]"
        select suppliers.first.name, from: "mixable[mixture_criteria][][kitchen_id]"
        fill_in 'mixable[mixture_criteria][][quantity]', with: '500'
        select units.first.name, from: "mixable[mixture_criteria][][unit_id]"
      end

      let(:create_a_consumable_type_with_ingredients) do
        fill_in_form
        fill_in_ingredients
        submit_form
      end

      it 'Allows a user to create a new Consumable Type with Ingredients' do
        expect { create_a_consumable_type_with_ingredients }
          .to change(ConsumableType, :count).by(1)
          .and change(Mixture, :count).by(1)

        mixture = Mixture.last
        expect(mixture.ingredient.consumable_type_id).to eq(consumable_types.first.id)
        expect(mixture.ingredient.number).to be_nil
        expect(mixture.ingredient.kitchen_id).to eq(consumable_types.first.id)
        expect(mixture.quantity).to eq(500)
        expect(mixture.unit_id).to eq(units.first.id)

        expect(page).to have_content("Consumable Type successfully created")
      end

      context 'when fields are missing in ingredients' do

        let(:create_a_consumable_type_with_error_in_ingredients) do
          fill_in_form
          fill_in_ingredients
          # Deselect a Supplier
          select '', from: "mixable[mixture_criteria][][kitchen_id]"
          submit_form
        end

        it 'shows an error' do
          expect { create_a_consumable_type_with_error_in_ingredients }
            .to change(ConsumableType, :count).by(0)
            .and change(Mixture, :count).by(0)

          expect(page).to have_content("error prohibited this record from being saved")
        end

      end

    end
  end

  describe '#edit' do

    let(:edit_a_consumable_type) do
      visit edit_consumable_type_path(saved_consumable_type)
      fill_in "Name*", with: consumable_type.name
      fill_in "Days to Keep", with: 9
      select "RT", from: "Storage condition"
      click_button "Update Consumable type"
    end

    it "Allows a user to edit an existing consumable type", js: true do
      expect { edit_a_consumable_type }.to change{ saved_consumable_type.reload.name }.to(consumable_type.name)
      expect(saved_consumable_type.days_to_keep).to eq(9)
      expect(saved_consumable_type.storage_condition).to eq("RT")
      expect(page).to have_content("Consumable Type successfully updated")
    end

    it "Creates a new Audit record" do
      expect { edit_a_consumable_type }.to change(Audit, :count).by(1)
    end
  end

end