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
      visit batch_path(@batch)

      expect(page).to have_content(@batch.consumables.first.volume.to_s)
      expect(page).to have_content(@batch.consumables.first.unit)
    end

    it 'displays correctly without storage conditions' do
      consumable_type = create(:consumable_type, storage_condition: nil)
      batch = create(:batch, consumable_type: consumable_type)

      visit batch_path(batch)

      expect(page).to have_content("Storage conditions: None specified")
    end

    it 'should display barcode type when per aliquot' do
      visit batch_path(@batch)

      expect(page).to have_content('per aliquot')
    end

    it 'should display barcode type when per batch' do
      batch = create(:batch, single_barcode: true)

      visit batch_path(batch)

      expect(page).to have_content('single')
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

    it 'tells the user if there\'s an error' do
      allow(PMB::PrintJob).to receive(:execute).and_raise(JsonApiClient::Errors::ServerError.new({}))

      visit batch_path(@batch)
      click_button "Print Labels"
      sleep 1
      select @printer.name, from: "Printer"
      click_button "Print"

      expect(page).to have_content("Your labels could not be printed")
    end

    xit 'tells the user the error if known' do
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
      @project = create(:project)
    end

    context 'when all required fields are filled in' do

      let(:create_batch) {
        visit new_batch_path
        select @batch.consumable_type.name, from: 'Consumable Type'
        fill_in "Use by date", with: @batch.expiry_date
        fill_in "mixable_sub_batches__quantity", with: 3
        fill_in "mixable_sub_batches__volume", with: 2.2
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

    context "when a user clicks the submit button" do
      let(:create_batch) {
        visit new_batch_path
        # important: this stops the submission so the page doesn't change;
        # but crucially doesn't stop UJS from doing its thing
        # https://stackoverflow.com/a/44414754
        execute_script("$('form').submit(function() { event.preventDefault() })")
        click_button "Create Batch"
      }

      it "submit is disabled and says 'Saving'" do
        create_batch
        expect(page).to have_button('Saving', disabled: true)
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

      it 'sets the use by date', js: true do
        select_a_consumable_type
        expect(find_field("Use by date").value).to eq(Date.today.advance(days: @consumable_type.days_to_keep).to_date.to_s(:default))
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

      it 'sets the use by date blank', js: true do
        select_a_consumable_type
        expect(find_field("Use by date").value).to be_blank
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
        all(:xpath, '//select[@name="mixable[mixture_criteria][][consumable_type_id]"]').last.select(@consumable_type.name)
        all(:xpath, '//input[@name="mixable[mixture_criteria][][number]"]').last.set('12345')
        all(:xpath, '//select[@name="mixable[mixture_criteria][][kitchen_id]"]').last.select(@team.name)
        fill_in "Use by date", with: @batch.expiry_date
        fill_in "mixable_sub_batches__quantity", with: 3
        click_button "Create Batch"
        click_button "Continue"
      }

      it 'displays a validation error' do
        fill_out_form
        expect(page).to have_content("with number 12345 could not be found")
      end

      it 'maintains the selected options' do
        fill_out_form
        expect(page).to have_select('Consumable Type', selected: @consumable_type.name)
        expect(page).to have_select('mixable[mixture_criteria][][consumable_type_id]', selected: @consumable_type.name)
        expect(find(:xpath, '//input[@name="mixable[mixture_criteria][][number]"]').value).to eq('12345')
        expect(page).to have_select('mixable[mixture_criteria][][kitchen_id]', selected: @team.name)
        expect(find_field("Use by date").value).to eq(@batch.expiry_date.to_s)
        # Leaving the following line in case persistence is still required with sub-batch info
        #expect(find_field("mixable_sub_batches__quantity").value).to eq("3")
      end

    end

    context 'when a selected consumable type has ingredients' do

      let!(:unit) { create(:unit) }

      before do
        @consumable_type = create(:consumable_type_with_recipe)
        @lot             = create(:lot, consumable_type: @consumable_type)
        @batch           = create(:batch)
      end

      let(:fill_out_form) {
        visit new_batch_path
        select @consumable_type.name, from: 'Consumable Type'
        fill_in "Use by date", with: (@batch.expiry_date.to_s + "\t")
        sleep(0.5)
        find_field("mixable[expiry_date]").native.send_key(:Tab)
        sleep(0.5)
        fill_in "mixable_sub_batches__quantity", with: 3
        fill_in "mixable_sub_batches__volume", with: 1.1
      }

      def quantity_and_unit(mixture)
        { quantity: mixture.quantity, unit_id: mixture.unit_id }
      end

      it 'saves the batch with the consumable type\'s recipe' do
        fill_out_form
        click_button "Create Batch"
        expect(page).to have_content("Reagent batch successfully created")

        batch = Batch.last
        expect(batch.ingredients.size).to eq(@consumable_type.mixtures.size)
        expect(batch.mixture_criteria).to eq(@consumable_type.mixture_criteria)
        expect(batch.ingredients.map(&:consumable_type_id)).to eq(@consumable_type.mixtures.map { |mixture| mixture.ingredient.consumable_type_id})
        expect(batch.ingredients.map(&:kitchen_id)).to eq(@consumable_type.mixtures.map { |mixture| mixture.ingredient.kitchen_id })
        expect(batch.mixtures.map(&method(:quantity_and_unit))).to eq(@consumable_type.mixtures.map(&method(:quantity_and_unit)))
      end

      describe 'editing ingredients' do
        it 'can remove an ingredient' do
          fill_out_form
          all(:data_behavior, "remove_row").first.click
          sleep 1 # Allow the animation to finish...
          click_button "Create Batch"
          click_button "Continue"

          expect(page).to have_content("Reagent batch successfully created")

          batch = Batch.last
          expect(batch.ingredients.size).to eq(@consumable_type.mixtures.size - 1)
          expect(batch.mixture_criteria).to eq(@consumable_type.mixture_criteria.drop(1))
        end

        it 'can add an ingredient' do
          fill_out_form
          click_button("Add Ingredient")

          all(:xpath, '//select[@name="mixable[mixture_criteria][][consumable_type_id]"]').last.select(@lot.consumable_type.name)
          all(:xpath, '//input[@name="mixable[mixture_criteria][][number]"]').last.set(@lot.number)
          all(:xpath, '//select[@name="mixable[mixture_criteria][][kitchen_id]"]').last.select(@lot.kitchen.name)

          click_button "Create Batch"
          click_button "Continue"

          expect(page).to have_content("Reagent batch successfully created")

          batch = Batch.last

          expect(batch.ingredients.size).to eq(@consumable_type.mixtures.size + 1)
          new_mixture_criterium = {
            consumable_type_id: @lot.consumable_type_id,
            number: @lot.number,
            kitchen_id: @lot.kitchen_id,
            quantity: nil,
            unit_id: nil
          }
          all_ingredients = @consumable_type.mixture_criteria.push(new_mixture_criterium)
          expect(batch.mixture_criteria).to eq(all_ingredients)
        end

        it 'can add an ingredient with a quantity and unit' do
          fill_out_form
          click_button("Add Ingredient")

          all(:xpath, '//select[@name="mixable[mixture_criteria][][consumable_type_id]"]').last.select(@lot.consumable_type.name)
          all(:xpath, '//input[@name="mixable[mixture_criteria][][number]"]').last.set(@lot.number)
          all(:xpath, '//select[@name="mixable[mixture_criteria][][kitchen_id]"]').last.select(@lot.kitchen.name)
          all(:xpath, '//input[@name="mixable[mixture_criteria][][quantity]"]').last.set(500)
          all(:xpath, '//select[@name="mixable[mixture_criteria][][unit_id]"]').last.select(unit.name)

          click_button "Create Batch"
          click_button "Continue"

          expect(page).to have_content("Reagent batch successfully created")

          batch = Batch.last

          expect(batch.ingredients.size).to eq(@consumable_type.mixtures.size + 1)

          last_mixture = batch.mixtures.last
          expect(last_mixture.ingredient).to eq(@lot)
          expect(last_mixture.quantity).to eq(500)
          expect(last_mixture.unit).to eq(unit)

          new_mixture_criterium = new_mixture_criterium = {
            consumable_type_id: @lot.consumable_type_id,
            number: @lot.number,
            kitchen_id: @lot.kitchen_id,
            quantity: 500,
            unit_id: unit.id
          }
          all_ingredients = @consumable_type.mixture_criteria.push(new_mixture_criterium)
          expect(batch.mixture_criteria).to eq(all_ingredients)
        end

        it 'adding new ingredient doesnt reset other ingredients' do
          fill_out_form
          click_button("Add Ingredient")

          all(:xpath, '//select[@name="mixable[mixture_criteria][][consumable_type_id]"]').last.select(@lot.consumable_type.name)
          all(:xpath, '//input[@name="mixable[mixture_criteria][][number]"]').last.set(@lot.number)
          all(:xpath, '//select[@name="mixable[mixture_criteria][][kitchen_id]"]').last.select(@lot.kitchen.name)

          click_button("Add Ingredient")
          within("table#mixable-ingredients-table") do
            all(:data_behavior, "remove_row").last.click
          end
          sleep 1

          click_button "Create Batch"
          click_button "Continue"

          expect(page).to have_content("Reagent batch successfully created")

          batch = Batch.last

          expect(batch.ingredients.size).to eq(@consumable_type.mixtures.size + 1)

          new_mixture_criterium = new_mixture_criterium = {
            consumable_type_id: @lot.consumable_type_id,
            number: @lot.number,
            kitchen_id: @lot.kitchen_id,
            quantity: nil,
            unit_id: nil
          }
          all_ingredients = @consumable_type.mixture_criteria.push(new_mixture_criterium)

          expect(batch.mixture_criteria).to eq(all_ingredients)
        end

        it 'can scan in an ingredient' do
          fill_out_form

          # Get a consumable from a batch that's already been created

          consumable = @batch.consumables.first
          consumable_barcode = find("#consumable-barcode input")
          consumable_barcode.set(consumable.barcode)

          consumable_barcode.native.send_key(:Enter)

          wait_for_ajax
          click_button "Create Batch"
          click_button "Continue"
          expect(page).to have_content("Reagent batch successfully created")

          batch = Batch.last
          expect(batch.ingredients.size).to eq(@consumable_type.mixtures.size + 1)
          expect(batch.ingredients.include?(consumable.batch)).to be_truthy

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
        fill_in "Use by date", with: @batch.expiry_date
        fill_in "mixable_sub_batches__quantity", with: 3
        fill_in "mixable_sub_batches__volume", with: 100
      }
      let("submit") {
        click_button('Create Batch')
      }

      context 'is given' do
        it 'will create volume and units' do
          fill_in_required
          fill_in "mixable_sub_batches__volume", with: 2
          submit

          expect(Batch.last.consumables.first.volume).to eql(2.0)
          expect(Batch.last.consumables.first.unit).to eql(SubBatch.units.keys.first)
        end
      end
    end

    describe 'when generate single barcode dropdown' do
      let(:fill_in_required) {
        visit new_batch_path
        select @batch.consumable_type.name, from: 'Consumable Type'
        fill_in "mixable_sub_batches__quantity", with: 3
        fill_in "mixable_sub_batches__volume", with: 100
      }
      let("submit") {
        click_button('Create Batch')
      }

      context 'is set to "per aliquot"' do
        it 'will make three different barcodes' do
          fill_in_required
          select "per aliquot", from: "mixable_sub_batches__barcode_type"
          submit

          expect(Batch.last.consumables.count).to eq(3)
          expect(Batch.last.consumables[0].barcode).to_not eq(Batch.last.consumables[1].barcode)
          expect(Batch.last.consumables[0].barcode).to_not eq(Batch.last.consumables[2].barcode)
          expect(Batch.last.consumables[1].barcode).to_not eq(Batch.last.consumables[2].barcode)
        end
      end

      context 'is set to "single"' do
        it 'will make a single barcode' do
          fill_in_required
          select "single", from: "mixable_sub_batches__barcode_type"
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

      fill_in "mixable_sub_batches__quantity", with: 3
      fill_in "mixable_sub_batches__volume", with: 5
      select "mL", from: "mixable_sub_batches__unit"

      #TODO: following line causing fail due to broken volume calculator
      expect(page.find('#calculated_batch_volume').value).to eq('0.015')
    end

    it 'shouldn\'t cause errors when setting consumable type to blank' do
      consumable_type = create(:consumable_type)
      visit new_batch_path

      select consumable_type.name, from: 'Consumable Type'
      select '', from: 'Consumable Type'
    end

  end

  describe "#print" do
    it 'should return the id of the last label template that type was printed to' do
      consumable_type = create(:consumable_type, id: 9, last_label_id: 180)
      batch = create(:batch, consumable_type_id: 9)

      expect(batch.consumable_type.last_label_id).to eq(180)
    end

    it 'should update the id of the last label template upon printing' do
      label_old = create(:label_type, name: "Big labels")
      label_new = create(:label_type, name: "Small labels")
      printer_old = create(:printer, label_type: label_old)
      printer_new = create(:printer, label_type: label_new)
      consumable_type = create(:consumable_type, id: 54, last_label_id: label_old.id)
      batch = create(:batch, consumable_type_id: 54)

      allow(PMB::PrintJob).to receive(:execute).and_return(true)

      visit batch_path(batch)
      click_button "Print Labels"
      sleep 1
      select label_new.name, from: "Label template"
      click_button "Print"

      consumable_type.reload

      expect(consumable_type[:last_label_id]).to eq(label_new.id)

    end
  end

  describe "#edit" do
    before :each do
      test_user = create(:user)
      @consumable_type1 = create(:consumable_type)
      @consumable_type2 = create(:consumable_type)

      @batch = create(:batch, user_id: test_user.id, consumable_type_id: @consumable_type1.id,
        ingredients: [create(:ingredient)])

      @batch2 = create(:batch, user_id: test_user.id, consumable_type_id: @consumable_type2.id)
    end

    context "submitting invalid info" do
      before :each do
        visit edit_batch_path(@batch)
        @batch_orig = { consumable_type: @batch.consumable_type.name,
          expiry_date: @batch.expiry_date.to_s,
          consumables_count: @batch.consumables.count.to_s,
          aliquot_volume: @batch.consumables.first.volume.to_s,
          aliquot_unit: @batch.consumables.first.unit,
          ingredients: @batch.ingredients }

        select "", from: "mixable_consumable_type_id"
        fill_in "mixable_expiry_date", with: ""
        fill_in "mixable_sub_batches__quantity", with: ""
        fill_in "mixable_sub_batches__volume", with: ""

        click_button "Save Changes"
        sleep 1
      end

      it "shows the applicable error(s)" do
        within("div.alert-danger") do
          expect(page).to have_css("li", count: 3)
        end
      end

      it "doesn't update the record with invalid information" do
        visit batch_path(@batch)
        expect(page).to have_text("Consumable type: " + @batch_orig[:consumable_type])
        expect(page).to have_text("Use by date: " + @batch_orig[:expiry_date])
        expect(page).to have_text(@batch_orig[:consumables_count])

        within("table#sub-batch-table tbody") do
          expect(page).to have_text(@batch_orig[:aliquot_volume])
          expect(page).to have_text(@batch_orig[:aliquot_unit])
        end

        # ensure the ingredients list shows the same number as pre-edit
        within("table#ingredients-table tbody") do
          expect(page).to have_selector("tr", count: @batch_orig[:ingredients].count)
        end
      end
    end

    context "viewing the edit form" do
      let!(:unit) { create(:unit) }

      it "populates the form with the info from the current batch" do
        @batch.mixtures.first.update_attributes!(quantity: 500, unit: unit)
        visit edit_batch_path(@batch)
        expect(page).to have_select("mixable_consumable_type_id", selected: @batch.consumable_type.name)
        expect(page).to have_select("mixable_ingredients__consumable_type_id", selected: @batch.ingredients.first.consumable_type.name)
        expect(page).to have_field("mixable_ingredients__quantity", with: "500")
        expect(page).to have_select("mixable_ingredients__unit_id", selected: unit.name)

        expect(page).to have_field("mixable_expiry_date", with: @batch.expiry_date.to_s)
        expect(page).to have_field("mixable_sub_batches__quantity", with: @batch.consumables.count)
        expect(page).to have_field("mixable_sub_batches__volume", with: @batch.consumables.first.volume)
        expect(page).to have_select("mixable_sub_batches__unit", selected: @batch.consumables.first.unit)
        expect(page).to have_select("mixable_sub_batches__barcode_type", selected: "per aliquot")

      end

      it "shows the correct favourite status of the consumable type" do
        @fav = create(:favourite, user_id: test_user.id, consumable_type_id: @consumable_type1.id)
        visit edit_batch_path(@batch)
        expect(page).to have_select("mixable_consumable_type_id", selected: @consumable_type1.name)
        expect(page).to have_selector("i.fa.fa-star.fa-3x.favourite")
      end

      it "shows 'Save Changes' on the submit button" do
        visit edit_batch_path(@batch)
        expect(page).to have_button("Save Changes")
      end

      it "shows the title of the batch at the top of the form" do
        visit edit_batch_path(@batch)
        expect(page).to have_css("h2", text: 'Editing Batch: ' + @batch.number)
      end
    end

    context "submitting the form" do
      let!(:unit) { create(:unit) }

      it "updates the appropriate records" do
        @external_team = create(:supplier)

        visit edit_batch_path(@batch)
        # consumable type dropdown
        select @consumable_type2.name, from: "mixable_consumable_type_id"

        # ingredients form
        click_button("Add Ingredient")
        select @consumable_type2.name, from: "mixable_ingredients__consumable_type_id"
        select @external_team.name, from: "mixable_ingredients__kitchen_id"

        # rest of form
        fill_in "mixable_expiry_date", with: "11/11/2021"
        fill_in "mixable_sub_batches__quantity", with: 74
        fill_in "mixable_sub_batches__volume", with: 9
        select "mL", from: "mixable_sub_batches__unit"
        select "single", from: "mixable_sub_batches__barcode_type"
        click_button "Save Changes"
        click_button "Continue"

        visit batch_path(@batch)

        expect(page).to have_text("Consumable type: " + @consumable_type2.name)
        expect(page).to have_text("Use by date: 11/11/2021")
        expect(page).to have_text("74")
        expect(page).to have_text("0.666L")
        expect(page).to have_text("single")
        expect(page).to have_text(@external_team.name)
      end

      it "updates the quantity and unit" do
        @external_team = create(:supplier)

        visit edit_batch_path(@batch)
        # consumable type dropdown
        select @consumable_type2.name, from: "mixable_consumable_type_id"

        # ingredients form
        click_button("Add Ingredient")
        select @consumable_type2.name, from: "mixable_ingredients__consumable_type_id"
        select @external_team.name, from: "mixable_ingredients__kitchen_id"
        select unit.name, from: "mixable_ingredients__unit_id"
        fill_in "mixable_ingredients__quantity", with: "800"

        # rest of form
        fill_in "mixable_expiry_date", with: "11/11/2021"
        fill_in "mixable_sub_batches__quantity", with: 74
        fill_in "mixable_sub_batches__volume", with: 9

        select "mL", from: "mixable_sub_batches__unit"
        select "single", from: "mixable_sub_batches__barcode_type"
        click_button "Save Changes"
        click_button "Continue"

        visit batch_path(@batch)
        expect(page).to have_text("Consumable type: " + @consumable_type2.name)
        expect(page).to have_text("Use by date: 11/11/2021")
        expect(page).to have_text("74")
        expect(page).to have_text("0.666L")
        expect(page).to have_text("single")
        expect(page).to have_text("800")
        expect(page).to have_text(unit.name)
        expect(page).to have_text(@external_team.name)
      end

      it "shows a message upon successful update" do
        visit edit_batch_path(@batch)
        click_button("Save Changes")
        click_button("Continue")

        expect(page).to have_text("Reagent batch successfully updated!")
      end
    end

    context "trying to edit a printed batch" do
      it "shows an error if you try to access the URL" do
        @batch.update(editable: false)
        visit edit_batch_path(@batch)
        expect(current_path).to eq "/batches"
        expect(page).to have_text("This batch has already been printed, so can't be modified.")
      end

      it "disables the 'Edit Batch' button when viewing a batch" do
        @batch.update(editable: false)
        visit batch_path(@batch)
        expect(page).to_not have_button("Edit Batch")
      end

      it "doesn't show the corresponding pencil when viewing the batch index" do
        @batch.update(editable: false)
        visit batches_path
        all("table tbody tr").each do |row|
          if row.text.include?(@batch2.consumable_type.name)
            expect(row).to have_selector("i.fa.fa-pencil")
          elsif row.text.include?(@batch.consumable_type.name)
            expect(row).to_not have_selector("i.fa.fa-pencil")
          end
        end
      end

    end
  end

  describe "consumables" do
    context "updating a consumable" do
      it "updates the updated_at column in the parent batch" do

        batch = create(:batch)
        batch.sub_batches.first.consumables.destroy_all

        expect {
          batch.sub_batches.first.consumables = create_list(:consumable, 12, sub_batch: batch.sub_batches.first)
        }.to change { batch.reload.updated_at }

      end
    end
  end

end
