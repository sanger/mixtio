require "rails_helper"

RSpec.describe "Batches", type: feature do

  describe '#index' do
    it 'displays them' do
      batch = create(:batch)

      visit batches_path

      expect(page).to have_content(batch.lot.name)
      expect(page).to have_content(batch.lot.consumable_type.name)
    end
  end

  describe '#new' do

    before do
      @batch = build(:batch)
    end

    context 'when all required fields are filled in' do

      let(:create_batch) {
        visit new_batch_path
        select @batch.lot.consumable_type.name, from: 'Consumable Type'
        select @batch.lot.supplier.name, from: 'Supplier'
        fill_in "Lot Name", with: @batch.lot.name
        fill_in "Expiry Date", with: @batch.expiry_date
        fill_in "Number of Aliquots", with: 3

        click_button "Create Batch"
      }

      it 'displays a success message' do
        create_batch
        expect(page).to have_content("Reagent batch successfully created")
      end

      it 'creates a new batch' do
        expect{ create_batch }.to change{ Batch.count }.by(1)
      end

      it 'creates a new consumable' do
        expect { create_batch }.to change { Consumable.count }.by(3)
      end

    end

    context 'when fields are missing' do

      let(:create_batch) {
        visit new_batch_path
        click_button "Create Batch"
      }

      it 'displays an error' do
        create_batch
        expect(page).to have_content('errors prohibited this record from being saved')
      end
    end

    context 'when a consumable type is selected' do
      before do
        @consumable_type = create(:consumable_type)
      end

      let(:select_a_consumable_type) {
        visit new_batch_path
        select @consumable_type.name, from: 'Consumable Type'
        wait_for_ajax
      }

      it 'sets the exiry date', js: true do
        select_a_consumable_type
        expect(find_field("Expiry Date").value).to eq(@consumable_type.expiry_date_from_today)
      end
    end

    context 'when the lot name does not exist' do

      before do
        @batch = build(:batch, lot: nil)
        @lot = build(:lot)
        @consumable_type = create(:consumable_type)
        @supplier = create(:supplier)
      end

      let(:create_batch) {
        visit new_batch_path
        select @consumable_type.name, from: 'Consumable Type'
        select @supplier.name, from: 'Supplier'
        fill_in "Lot Name", with: @lot.name
        fill_in "Expiry Date", with: @batch.expiry_date
        fill_in "Number of Aliquots", with: 3

        click_button "Create Batch"
      }

      it 'creates a new lot' do
        expect{ create_batch }.to change{ Lot.count }.by(1)
        expect(page).to have_content("Reagent batch successfully created")
        # How else can I find the batch??
        expect(Batch.last.lot.name).to eq(@lot.name)
      end

    end

    context 'when a selected consumable type has ingredients', js: true do

      before do
        @consumable_type = create(:consumable_type_with_ingredients_with_lots)
        @lot = create(:lot)
      end

      let(:fill_out_form) {
        visit new_batch_path
        select @consumable_type.name, from: 'Consumable Type'
        wait_for_ajax
        select @batch.lot.supplier.name, from: 'Supplier'
        fill_in "Lot Name", with: @batch.lot.name
        fill_in "Expiry Date", with: @batch.expiry_date
        fill_in "Number of Aliquots", with: 3
      }

      it 'saves each consumable with the consumable type\'s latest ingredients' do
        fill_out_form
        click_button "Create Batch"
        expect(page).to have_content("Reagent batch successfully created")

        batch = Batch.last
        expect(batch.ingredients.size).to eq(3)
        expect(batch.ingredients).to eq(@consumable_type.latest_ingredients)
      end

      describe 'editing ingredients' do
        it 'can remove an ingredient' do
          fill_out_form
          all(:data_behavior, "remove_row").last.click
          sleep 1 # Allow the animation to finish...
          click_button "Create Batch"
          expect(page).to have_content("Reagent batch successfully created")

          batch = Batch.last
          expect(batch.ingredients.size).to eq(2)
          expect(batch.ingredients).to eq(@consumable_type.latest_ingredients.take(2))
        end

        it 'can add an ingredient' do
          fill_out_form
          click_button("Add Ingredient")

          all(:xpath, '//select[@name="batch_form[lots][][consumable_type_id]"]').last.select(@lot.consumable_type.name)
          all(:xpath, '//input[@name="batch_form[lots][][name]"]').last.set(@lot.name)
          all(:xpath, '//select[@name="batch_form[lots][][supplier_id]"]').last.select(@lot.supplier.name)

          click_button "Create Batch"

          expect(page).to have_content("Reagent batch successfully created")

          batch = Batch.last

          expect(batch.ingredients.size).to eq(4)

          all_ingredients = @consumable_type.latest_ingredients << @lot

          expect(batch.ingredients).to eq(all_ingredients)

        end

        before do
          @consumable = create(:consumable)
        end

        it 'can scan in an ingredient', js: true do
          fill_out_form
          find("#consumable-barcode").set(@consumable.barcode)
          click_button("Add Ingredient")
          wait_for_ajax

          click_button "Create Batch"

          expect(page).to have_content("Reagent batch successfully created")

          batch = Batch.last
          expect(batch.ingredients.size).to eq(4)
          expect(batch.ingredients.include?(@consumable.batch.lot)).to be_truthy

        end
      end

    end

  end
end