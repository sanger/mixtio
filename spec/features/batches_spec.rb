require "rails_helper"

RSpec.describe "Batches", type: feature, js: true do

  before(:each) do
    sign_in
  end

  describe '#show' do

    before :each do
      @batch   = create(:batch)
      @printer = create(:printer)
    end

    it 'displays the batch' do
      visit batch_path(@batch)

      expect(page).to have_content(@batch.number)
      expect(page).to have_content(@batch.kitchen.name)
      expect(page).to have_content(@batch.user.username)
      expect(page).to have_content(@batch.consumable_type.name)
      expect(page).to have_content(@batch.expiry_date)
      expect(page).to have_content(@batch.consumable_type.storage_condition)
      expect(page).to have_content(@batch.consumables.length)
      expect(page).to have_content(@batch.display_volume)
      expect(page).to_not have_content("Aliquot Volume")
    end

    it 'displays volume when aliquot has volume' do
      batch = create(:batch)
      batch.consumables.create!(Array.new(1, {volume: 4, unit: 'mL'}))

      visit batch_path(batch)

      expect(page).to have_content(batch.consumables.first.display_volume)
      expect(page).to have_content("Aliquot Volume")
    end

    it 'displays correctly without storage conditions' do
      consumable_type = create(:consumable_type, storage_condition: nil)
      batch = create(:batch, consumable_type: consumable_type)

      visit batch_path(batch)

      expect(page).to have_content("Storage conditions: None specified")
    end

    it 'should display barcode type when per aliquot' do
      batch = create(:batch)
      batch.consumables = create_list(:consumable, 3)

      visit batch_path(batch)

      expect(page).to have_content('Barcode Type: One per aliquot')
    end

    it 'should display barcode type when per batch' do
      batch = create(:batch)
      batch.consumables = create_list(:consumable, 3, barcode: 'RGNT_1')

      visit batch_path(batch)

      expect(page).to have_content('Barcode Type: One per batch')
    end

    it 'prints labels for the batch' do
      allow(PMB::PrintJob).to receive(:execute).and_return(true)

      visit batch_path(@batch)
      click_button "Print Labels"
      sleep 1
      select @printer.name, from: "Printer"
      click_button "Print"

      expect(page).to have_content("Your labels have been printed")
    end

    it 'tells the user if there\'s and error' do
      allow(PMB::PrintJob).to receive(:execute).and_raise(JsonApiClient::Errors::ServerError.new({}))

      visit batch_path(@batch)
      click_button "Print Labels"
      sleep 1
      select @printer.name, from: "Printer"
      click_button "Print"

      expect(page).to have_content("Your labels could not be printed")
    end

    it 'tells the user the error if known' do
      pending 'Need PMB to be fixed first'
      exception = RestClient::Exception.new(OpenStruct.new(code: 422, to_str: '{"errors":{"printer":["Printer does not exist"]}}'))
      allow(RestClient).to receive(:post).and_raise(exception)

      visit batch_path(@batch)
      click_button "Print Labels"
      sleep 1
      select @printer.name, from: "Printer"
      click_button "Print"

      expect(page).to have_content("Your labels could not be printed")
      expect(page).to have_content("Printer does not exist")
    end

    it 'should show the relevant printers to the selected label type' do
      type_1    = create(:label_type)
      type_2    = create(:label_type)
      printer_1 = create(:printer, label_type: type_1)
      printer_2 = create(:printer, label_type: type_1)
      printer_3 = create(:printer, label_type: type_2)
      printer_4 = create(:printer, label_type: type_2)

      visit batch_path(@batch)
      click_button "Print Labels"
      sleep 1

      select type_1.name, from: 'Label template'
      expect(find('#printer').all('option').collect(&:text)).to include(printer_1.name)
      expect(find('#printer').all('option').collect(&:text)).to include(printer_2.name)

      select type_2.name, from: 'Label template'
      expect(find('#printer').all('option').collect(&:text)).to include(printer_3.name)
      expect(find('#printer').all('option').collect(&:text)).to include(printer_4.name)
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
        fill_in "Aliquot volume", with: 2.2
        click_button('Create Batch')
      }

      it 'displays a success message' do
        create_batch
        expect(page).to have_content("Reagent batch successfully created")
      end

      it 'creates a new batch' do
        expect { create_batch }.to change { Batch.count }.by(1)
      end

      it 'creates a new consumable' do
        expect { create_batch }.to change { Consumable.count }.by(3)
      end

      it 'creates a new audit record' do
        expect { create_batch }.to change { Audit.count }.by(1)
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
        expect(find_field("Expiry Date").value).to eq(Date.today.advance(days: @consumable_type.days_to_keep).to_date.to_s(:default))
      end
    end

    context 'when a consumable type is selected that has a days_to_keep of 0' do
      before do
        @consumable_type = create(:consumable_type, days_to_keep: 0)
      end

      let(:select_a_consumable_type) {
        visit new_batch_path
        select @consumable_type.name, from: 'Consumable Type'
        wait_for_ajax
      }

      it 'sets the expiry date to today', js: true do
        select_a_consumable_type
        expect(find_field("Expiry Date").value).to eq(Date.today.to_date.to_s(:default))
      end
    end

    context 'when trying to use a batch that does not exist as an ingredient' do

      before do
        @consumable_type = create(:consumable_type)
        @team            = create(:team)
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

      it 'maintains the selected options' do
        fill_out_form
        expect(page).to have_select('Consumable Type', selected: @consumable_type.name)
        expect(page).to have_select('batch_form[ingredients][][consumable_type_id]', selected: @consumable_type.name)
        expect(find(:xpath, '//input[@name="batch_form[ingredients][][number]"]').value).to eq('12345')
        expect(page).to have_select('batch_form[ingredients][][kitchen_id]', selected: @team.name)
        expect(find_field("Expiry Date").value).to eq(@batch.expiry_date.to_s)
        expect(find_field("Number of Aliquots").value).to eq("3")
      end

    end

    context 'when a selected consumable type has ingredients' do

      before do
        @consumable_type = create(:consumable_type)
        @lot             = create(:lot, consumable_type: @consumable_type)
        @previous_batch  = create(:batch_with_ingredients, consumable_type: @consumable_type)
      end

      let(:fill_out_form) {
        visit new_batch_path
        select @consumable_type.name, from: 'Consumable Type'
        fill_in "Expiry Date", with: @batch.expiry_date
        fill_in "Number of Aliquots", with: 3
        fill_in "Aliquot volume", with: 1.1
      }

      it 'saves the batch with the consumable type\'s latest ingredients' do
        fill_out_form
        click_button "Create Batch"
        expect(page).to have_content("Reagent batch successfully created")

        batch = Batch.last
        expect(batch.ingredients.size).to eq(3)
        expect(batch.ingredients).to eq(@previous_batch.ingredients)
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

        it 'adding new ingredient doesnt reset other ingredients' do
          fill_out_form
          click_button("Add Ingredient")

          all(:xpath, '//select[@name="batch_form[ingredients][][consumable_type_id]"]').last.select(@lot.consumable_type.name)
          all(:xpath, '//input[@name="batch_form[ingredients][][number]"]').last.set(@lot.number)
          all(:xpath, '//select[@name="batch_form[ingredients][][kitchen_id]"]').last.select(@lot.kitchen.name)

          click_button("Add Ingredient")
          all(:data_behavior, "remove_row").last.click
          sleep 1

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

    describe 'when an aliquot volume' do
      let(:fill_in_required) {
        visit new_batch_path
        select @batch.consumable_type.name, from: 'Consumable Type'
        fill_in "Expiry Date", with: @batch.expiry_date
        fill_in "Number of Aliquots", with: 3
        fill_in "Aliquot volume", with: 100
      }
      let("submit") {
        click_button('Create Batch')
      }

      context 'is given' do
        it 'will create volume and units' do
          fill_in_required
          fill_in "Aliquot volume", with: 2
          submit

          expect(Batch.last.consumables.first.volume).to eql(2)
          expect(Batch.last.consumables.first.unit).to eql(Consumable.units.keys.first)
        end
      end
    end

    describe 'when generate single barcode checkbox' do
      let(:fill_in_required) {
        visit new_batch_path
        select @batch.consumable_type.name, from: 'Consumable Type'
        fill_in "Number of Aliquots", with: 3
        fill_in "Aliquot volume", with: 100
      }
      let("submit") {
        click_button('Create Batch')
      }

      context 'is unchecked' do
        it 'will make three different barcodes' do
          fill_in_required
          submit

          expect(Batch.last.consumables.count).to eq(3)
          expect(Batch.last.consumables[0].barcode).to_not eq(Batch.last.consumables[1].barcode)
          expect(Batch.last.consumables[0].barcode).to_not eq(Batch.last.consumables[2].barcode)
          expect(Batch.last.consumables[1].barcode).to_not eq(Batch.last.consumables[2].barcode)
        end
      end

      context 'is checked' do
        it 'will make a single barcode' do
          fill_in_required
          check 'All aliquots share one barcode'
          submit

          expect(Batch.last.consumables.count).to eq(3)
          expect(Batch.last.consumables[0].barcode).to eq(Batch.last.consumables[1].barcode)
          expect(Batch.last.consumables[0].barcode).to eq(Batch.last.consumables[2].barcode)
          expect(Batch.last.consumables[1].barcode).to eq(Batch.last.consumables[2].barcode)
        end
      end
    end

    it 'should calculate the batch volume' do
      visit new_batch_path

      fill_in "Number of Aliquots", with: 3
      fill_in "Aliquot volume", with: 5
      select "mL", from: "Aliquot unit"

      expect(page.find('#calculated_batch_volume').value).to eq('0.015')
    end

    context 'when the selected consumable type has been made before' do

      before :each do
        @consumable_type = create(:consumable_type)
        @lot             = create(:lot, consumable_type: @consumable_type)
        @previous_batch  = create(:batch_with_consumables, consumable_type: @consumable_type)
      end

      let(:fill_out_form) {
        visit new_batch_path
        select @consumable_type.name, from: 'Consumable Type'
      }

      it 'should populate the previous aliquot values' do
        fill_out_form
        click_button "Create Batch"
        expect(page).to have_content("Reagent batch successfully created")

        batch = Batch.last
        expect(batch.consumables.count).to eq(@previous_batch.consumables.count)
        expect(batch.consumables.first.volume).to eq(@previous_batch.consumables.first.volume)
        expect(batch.consumables.first.unit).to eq(@previous_batch.consumables.first.unit)
      end

      it 'should update the batch volume' do
        fill_out_form

        expect(page.find('#calculated_batch_volume').value.to_f).to_not eq(0)
      end
    end

    it 'shouldn\'t cause errors when setting consumable type to blank' do
      consumable_type = create(:consumable_type)
      visit new_batch_path

      select consumable_type.name, from: 'Consumable Type'
      select '', from: 'Consumable Type'
    end
  end

  it 'should return the id of the last label template that type was printed to' do
    consumable_type = create(:consumable_type, id: 9, last_label_id: 180)
    batch = create(:batch, consumable_type_id: 9)

    expect(batch.consumable_type.last_label_id).to eq(180)
  end

  it 'should update the id of the last label template upon printing' do
    label_old = create(:label_type, name: "Big labels", external_id: 299)
    label_new = create(:label_type, name: "Small labels", external_id: 304)
    consumable_type = create(:consumable_type, id: 54, last_label_id: 299)
    batch = create(:batch, consumable_type_id: 54)
    printer_old = create(:printer, label_type: label_old)
    printer_new = create(:printer, label_type: label_new)

    allow(PMB::PrintJob).to receive(:execute).and_return(true)

    visit batch_path(batch)
    click_button "Print Labels"
    sleep 1
    select label_new.name, from: "Label template"
    click_button "Print"

    consumable_type.reload

    expect(consumable_type[:last_label_id]).to eq(304)

  end

end
