require 'rails_helper'

shared_examples_for "activatable" do
  let(:factory_name) { described_class.to_s.underscore.to_sym }

  describe 'activeness' do
    context 'when the item is active' do
      let(:item) { create(factory_name) }

      it { expect(item).to be_active }
      it { expect(item).not_to be_inactive }
      it 'should appear in the active scope' do
        expect(described_class.active).to include(item)
      end
      it 'should not appear in the inactive scope' do
        expect(described_class.inactive).not_to include(item)
      end
    end

    context 'when the item is inactive' do
      let(:item) { create(factory_name, active: false) }
      
      it { expect(item).to be_inactive }
      it { expect(item).not_to be_active }
      it 'should appear in the inactive scope' do
        expect(described_class.inactive).to include(item)
      end
      it 'should not appear in the active scope' do
        expect(described_class.active).not_to include(item)
      end
    end
  end

  describe '#activate!' do
    let(:item) { create(factory_name, active: false) }
    it 'should make the item active' do
      expect(item).not_to be_active
      item.activate!
      expect(item).to be_active
    end
  end

  describe '#deactivate!' do
    let(:item) { create(factory_name) }
    it 'should make the item inactive' do
      expect(item).to be_active
      item.deactivate!
      expect(item).not_to be_active
    end
  end
end
