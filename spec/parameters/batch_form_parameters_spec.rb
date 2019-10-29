require 'rails_helper'

RSpec.describe BatchFormParameters do

  let(:mixture_params) do
    Array.new(3, instance_double(MixtureParameters))
  end

  let(:sub_batches) { Array.new(3, double("sub_batch"))}
  let(:user) { build(:user) }
  let(:batch) { build(:batch) }

  let(:batch_form_parameters) do
    BatchFormParameters.new(
      consumable_type_id: 1,
      expiry_date: "25/11/2099",
      mixture_params: mixture_params,
      sub_batches: sub_batches,
      user: user,
      batch: batch,
      action: "create"
    )
  end

  describe 'attribute accessors' do
    it 'returns the right attributes' do
      expect(batch_form_parameters.consumable_type_id).to eql(1)
      expect(batch_form_parameters.expiry_date).to eql("25/11/2099")
      expect(batch_form_parameters.mixture_params).to eql(mixture_params)
      expect(batch_form_parameters.sub_batches).to eql(sub_batches)
      expect(batch_form_parameters.user).to eql(user)
      expect(batch_form_parameters.batch).to eql(batch)
      expect(batch_form_parameters.action).to eql("create")
      expect(batch_form_parameters.kitchen).to eql(user.team)
    end
  end

  describe '#valid?' do

    it 'calls valid? on each MixtureParameter' do
      expect(batch_form_parameters.mixture_params).to all(receive(:valid?))
      batch_form_parameters.valid?
    end

  end

end
