require 'rails_helper'

RSpec.describe ConsumableTypeForm do

  let(:consumable_type) { nil }
  let(:consumable_type_params) { build(:consumable_type, days_to_keep: 999, storage_condition: 'RT') }
  let(:name) { consumable_type_params.name }
  let(:days_to_keep) { consumable_type_params.days_to_keep }
  let(:storage_condition) { consumable_type_params.storage_condition }
  let(:user) { create(:user) }
  let(:mixture_criteria) { [] }

  let(:params) do
    {
      name: name,
      days_to_keep: days_to_keep,
      storage_condition: storage_condition,
      current_user: user,
      mixture_criteria: mixture_criteria,
      consumable_type: consumable_type
    }
  end

  let(:consumable_type_form) { ConsumableTypeForm.new(params) }

  describe 'attributes' do

    it 'sets name' do
      expect(consumable_type_form.name).to eql(name)
    end

    it 'sets days_to_keep' do
      expect(consumable_type_form.days_to_keep).to eql(days_to_keep)
    end

    it 'sets storage_condition' do
      expect(consumable_type_form.storage_condition).to eql(storage_condition)
    end

    it 'sets current_user' do
      expect(consumable_type_form.current_user).to eql(user)
    end

  end

  describe 'delegation' do

    it 'delegates #persisted? to consumable_type' do
      expect(consumable_type_form.persisted?).to eql(false)
    end

    it 'delegateds #id to consumable_type' do
      expect(consumable_type_form.id).to eql(nil)
    end

  end

  describe '#save' do

    context 'when the ConsumableType is valid' do

      it 'saves the ConsumableType' do
        expect { consumable_type_form.save }.to change { ConsumableType.count }.by(1)
      end

      it 'creates an Audit' do
        expect { consumable_type_form.save }.to change { Audit.count }.by(1)
        audit = Audit.last
        expect(audit.user_id).to eql(user.id)
        expect(audit.action).to eql("create")
      end

      it 'returns true' do
        expect(consumable_type_form.save).to be true
      end

    end

    context 'when the ConsumableType is invalid' do

      let(:days_to_keep) { -1 }

      it 'does not save the ConsumableType' do
        expect { consumable_type_form.save }.to change { ConsumableType.count }.by(0)
      end

      it 'returns false' do
        expect(consumable_type_form.save).to be false
      end

      it 'sets validation errors' do
        consumable_type_form.save
        expect(consumable_type_form.errors).to_not be_empty
      end

    end

  end

  describe '#update' do

    let(:consumable_type) { create(:consumable_type) }

    let(:update_consumable_type) do
      consumable_type_form.update
    end

    context 'when the ConsumableType is valid' do

      it 'updates the ConsumableType' do
        update_consumable_type
        consumable_type.reload
        expect(consumable_type.name).to eql(consumable_type_params.name)
        expect(consumable_type.days_to_keep).to eql(consumable_type_params.days_to_keep)
        expect(consumable_type.storage_condition).to eql(consumable_type_params.storage_condition)
      end

      it 'creates an Audit' do
        expect { update_consumable_type }.to change { Audit.count }.by(1)
        audit = Audit.last
        expect(audit.user_id).to eql(user.id)
        expect(audit.action).to eql("update")
      end

      it 'returns true' do
        expect(update_consumable_type).to be true
      end

    end

    context 'when the ConsumableType is invalid' do

      let(:days_to_keep) { -1 }

      it 'does not save the ConsumableType' do
        expect(consumable_type.name).to_not eql(consumable_type_params.name)
        expect(consumable_type.days_to_keep).to_not eql(consumable_type_params.days_to_keep)
        expect(consumable_type.storage_condition).to_not eql(consumable_type_params.storage_condition)
      end

      it 'returns false' do
        expect(update_consumable_type).to be false
      end

      it 'sets validation errors' do
        update_consumable_type
        expect(consumable_type_form.errors).to_not be_empty
      end

    end

  end

end
