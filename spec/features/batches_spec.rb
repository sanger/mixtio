require "rails_helper"

RSpec.describe "Batches", type: feature, js: true do

  before(:each) do
    sign_in
  end

  describe '#show' do

    before :each do
      @batch = create(:batch)
      @printer = create(:printer)
    end

    it 'displays the batch' do
      visit batch_path(@batch)

      expect(page).to have_content(@batch.number)
      expect(page).to have_content(@batch.kitchen.name)
      expect(page).to have_content(@batch.consumable_type.name)
      expect(page).to have_content(@batch.expiry_date)
      expect(page).to have_content(@batch.consumables.length)
    end

    it 'prints labels for the batch' do
      allow(RestClient).to receive(:post).and_return(OpenStruct.new(:code => 200))

      visit batch_path(@batch)
      click_button "Print Labels"
      sleep 1
      select @printer.name, from: "Printer"
      click_button "Print"

      expect(page).to have_content("Your labels have been printed")
    end

  end

  describe '#index' do
    it 'displays them' do
      batch = create(:batch)

      visit batches_path

      expect(page).to have_content(batch.consumable_type.name)
      expect(page).to have_content(batch.number)
      expect(page).to have_content(batch.expiry_date)
    end
  end

  describe '#new' do

    before do
      @batch = build(:batch)
    end

    context 'when all required fields are filled in' do

      let(:create_batch) {
        visit new_batch_path
        select @batch.consumable_type.name, from: 'Consumable Type'
        fill_in "Expiry Date", with: @batch.expiry_date
        fill_in "Number of Aliquots", with: 3
        click_button('Create Batch')
      }

      it 'displays a success message' do
        create_batch
        expect(page).to have_content("Reagent batch successfully created")
      end

      it 'creates a new batch' do
        expect { create_batch }.to change{ Batch.count }.by(1)
      end

      it 'creates a new consumable' do
        expect { create_batch }.to change { Consumable.count }.by(3)
      end

      it 'creates a new audit record' do
        expect { create_batch }.to change{ Audit.count }.by(1)
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

      it 'sets the expiry date', js: true do
        select_a_consumable_type
        expect(find_field("Expiry Date").value).to eq(Date.today.advance(days: @consumable_type.days_to_keep).to_s(:uk))
      end
    end

    context 'when trying to use a batch that does not exist as an ingredient' do

      before do
        @consumable_type = create(:consumable_type)
        @team = create(:team)
      end

      let(:fill_out_form) {
        visit new_batch_path
        select @consumable_type.name, from: 'Consumable Type'
        click_button("Add Ingredient")
        all(:xpath, '//select[@name="batch_form[ingredients][][consumable_type_id]"]').last.select(@consumable_type.name)
        all(:xpath, '//input[@name="batch_form[ingredients][][number]"]').last.set('12345')
        all(:xpath, '//select[@name="batch_form[ingredients][][kitchen_id]"]').last.select(@team.name)
        fill_in "Expiry Date", with: @batch.expiry_date
        fill_in "Number of Aliquots", with: 3
        click_button "Create Batch"
      }

      it 'displays a validation error' do
        fill_out_form
        expect(page).to have_content("with number 12345 could not be found")
      end

    end

    context 'when a selected consumable type has ingredients' do

      before do
        @consumable_type = create(:consumable_type_with_ingredients)
        @lot = create(:lot)
      end

      let(:fill_out_form) {
        visit new_batch_path
        select @consumable_type.name, from: 'Consumable Type'
        wait_for_ajax
        fill_in "Expiry Date", with: @batch.expiry_date
        fill_in "Number of Aliquots", with: 3
      }

      it 'saves the batch with the consumable type\'s latest ingredients' do
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

          all(:xpath, '//select[@name="batch_form[ingredients][][consumable_type_id]"]').last.select(@lot.consumable_type.name)
          all(:xpath, '//input[@name="batch_form[ingredients][][number]"]').last.set(@lot.number)
          all(:xpath, '//select[@name="batch_form[ingredients][][kitchen_id]"]').last.select(@lot.kitchen.name)

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

        it 'can scan in an ingredient' do
          fill_out_form

          consumable_barcode = find("#consumable-barcode input")
          consumable_barcode.set(@consumable.barcode)
          consumable_barcode.native.send_key(:Enter)

          wait_for_ajax

          click_button "Create Batch"

          expect(page).to have_content("Reagent batch successfully created")

          batch = Batch.last
          expect(batch.ingredients.size).to eq(4)
          expect(batch.ingredients.include?(@consumable.batch)).to be_truthy

        end
      end

      context 'when a scanned barcode can not be found' do

        it 'will display an error' do
          visit new_batch_path
          consumable_barcode = find("#consumable-barcode input")
          consumable_barcode.set('fake barcode')
          consumable_barcode.native.send_key(:Enter)

          wait_for_ajax

          expect(page).to have_content("Unable to find Consumable with barcode fake barcode")
        end
      end

    end

  end
end