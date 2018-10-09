require 'spec_helper'

RSpec.shared_examples "mixable" do

  describe '#mixture_criteria' do

    context 'when mixable does not have any mixtures' do

      it 'returns an empty list' do
        expect(no_mixtures.mixture_criteria).to eql([])
      end

    end

    context 'when mixable does have mixtures' do

      it 'returns a list of mixable criteria' do
        mixture_criteria = with_mixtures.mixture_criteria

        expect(mixture_criteria).to all(be_a(Hash))

        with_mixtures.mixtures.each_with_index do |mixture, index|
          expect(mixture.ingredient.consumable_type_id).to eql(mixture_criteria[index][:consumable_type_id])
          expect(mixture.ingredient.number).to eql(mixture_criteria[index][:number])
          expect(mixture.ingredient.kitchen_id).to eql(mixture_criteria[index][:kitchen_id])
          expect(mixture.quantity).to eql(mixture_criteria[index][:quantity])
          expect(mixture.unit_id).to eql(mixture_criteria[index][:unit_it])
        end
      end

    end


  end

end