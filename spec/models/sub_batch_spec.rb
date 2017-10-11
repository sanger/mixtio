require 'rails_helper'

RSpec.describe SubBatch, type: :model do
  before(:each) do
    sign_in
  end

  describe "creating sub-batches", js: true do

    let :fill_in_one_sub_batch do
      page.fill_in "batch_form_sub_batches__quantity", with: rand(1..20)
      page.fill_in "batch_form_sub_batches__volume", with: rand(0.01..20.00).round(2)
      page.select "mL", from: "batch_form_sub_batches__unit"
      page.select "per aliquot", from: "batch_form_sub_batches__barcode_type"
    end

    context "with projects" do
      before :each do
        @consumable_type = create(:consumable_type)
        @project = create(:project)
        @project2 = create(:project)
        visit new_batch_path
        select @consumable_type.name, from: 'Consumable Type'
      end

      let :fill_in_additional_sub_batch do
        click_button "Add Sub-Batch"
        wait_for_ajax
        all(:xpath, '//input[@name="batch_form[sub_batches][][quantity]"]').last.set(rand(1..20))
        all(:xpath, '//input[@name="batch_form[sub_batches][][volume]"]').last.set(rand(0.01..20.00).round(2))
        all(:xpath, '//select[@name="batch_form[sub_batches][][unit]"]').last.select("mL")
        all(:xpath, '//select[@name="batch_form[sub_batches][][barcode_type]"]').last.select("single")
        all(:xpath, '//select[@name="batch_form[sub_batches][][project_id]"]').last.select(@project2.name)
      end

      let :create_succeed do
        click_button "Create Batch"
        expect(page).to have_content("Reagent batch successfully created")
      end

      let :create_fail do
        click_button "Create Batch"
        expect(page).to have_content("Sub-batch aliquots can't be empty")
        expect(page).to have_content("Sub-batch volume can't be empty")
      end

      it "allows creation of multiple sub-batches" do
        fill_in_one_sub_batch
        fill_in_additional_sub_batch
        create_succeed
      end

      it "allows creation of a single sub-batch" do
        fill_in_one_sub_batch
        create_succeed
      end

      it "prevents creation of a batch that contains no sub-batches" do
        create_fail
      end

      it "allows sub-batches to be created with either barcode type" do
        fill_in_one_sub_batch
        fill_in_additional_sub_batch
        create_succeed

        expect(Batch.last.sub_batches.first.single_barcode?).to be false
        expect(Batch.last.sub_batches.last.single_barcode?).to be true
      end
    end

    context "with no projects" do
      it "doesn't allow saving of a batch if the sub-batch has no project selected" do
        @consumable_type = create(:consumable_type)
        visit new_batch_path
        fill_in_one_sub_batch
        select @consumable_type.name, from: 'Consumable Type'
        click_button "Create Batch"
        expect(page).to have_content("Sub-batch project can't be empty")
      end
    end
  end

  describe "viewing sub-batches" do
    it "shows info for all sub-batches on the batch view screen" do
      batch = create(:batch_with_consumables)
      batch.sub_batches << create(:sub_batch, volume: 7, unit: "µL")
      batch.sub_batches.last.consumables = create_list(:consumable, 5, sub_batch: batch.sub_batches.last)
      visit batch_path(batch)

      batch.sub_batches.each do |sub_batch|
        within("tr#sub-batch-#{sub_batch.id}") do
          expect(page).to have_content(sub_batch.display_volume)
          expect(page).to have_content(sub_batch.consumables.count)
          if sub_batch.single_barcode?
            expect(page).to have_content("single")
          else
            expect(page).to have_content("per aliquot")
          end
          expect(page).to have_content(sub_batch.project.name)
        end
      end


    end
  end

  describe "editing sub-batches" do
    before :each do
      @batch = create(:batch_with_consumables)
      @batch.sub_batches << create(:sub_batch, volume: 12, unit: "mL")
      @batch.sub_batches.last.consumables = create_list(:consumable, 4, sub_batch: @batch.sub_batches.last)
      @new_project = create(:project)
      visit edit_batch_path(@batch)
    end

    it "shows the correct info for each sub-batch", js: true do
      wait_for_ajax
      @batch.sub_batches.each do |sub_batch|
        within("table#batch-sub-batch-table tr#sub-batch-#{sub_batch.id}") do
          expect(page).to have_field("batch_form_sub_batches__quantity", with: sub_batch.quantity)

          if sub_batch.volume != sub_batch.volume.to_i # Decimals .01-.99
            expect(page).to have_field("batch_form_sub_batches__volume", with: sub_batch.volume)
          else # Volumes ending in .00 have it trimmed in the text field
            expect(page).to have_field("batch_form_sub_batches__volume", with: sub_batch.volume.to_i)
          end

          expect(page).to have_select("batch_form_sub_batches__unit", selected: sub_batch.unit)

          if sub_batch.single_barcode?
            expect(page).to have_select("batch_form_sub_batches__barcode_type", selected: "single")
          else
            expect(page).to have_select(selected: "per aliquot")
          end

          expect(page).to have_select("batch_form_sub_batches__project_id", selected: sub_batch.project.name)
        end
      end
    end

    it "updates the sub-batch record to reflect the changes", js: true do
      wait_for_ajax
      orig_sub_batch = @batch.sub_batches.first
      within("table#batch-sub-batch-table tr#sub-batch-#{orig_sub_batch.id}") do
        page.fill_in "batch_form_sub_batches__quantity", with: orig_sub_batch.quantity + 7
        page.fill_in "batch_form_sub_batches__volume", with: orig_sub_batch.volume + 2.12
        page.select "L", from: "batch_form_sub_batches__unit"
        page.select "single", from: "batch_form_sub_batches__barcode_type"
        page.select @new_project.name, from: "batch_form_sub_batches__project_id"
      end

      click_button "Save Changes"

      within(first("table#sub-batch-table tbody tr")) do
          expect(page).to have_content((orig_sub_batch.quantity + 7).to_s)
          expect(page).to have_content((orig_sub_batch.volume + 2.12).to_s + "L")
          expect(page).to have_content("single")
          expect(page).to have_content(@new_project.name)
      end

    end
  end
end
