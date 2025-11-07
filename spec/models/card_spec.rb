require 'rails_helper'

RSpec.describe Card, type: :model do
  let(:described_instance) { create(:card) }
  subject { described_instance }

  describe 'associations' do
    it { is_expected.to belong_to(:list) }
  end

  describe 'validations' do
    it { is_expected.to validate_length_of(:title).is_at_least(1).is_at_most(255) }
    it { is_expected.to validate_length_of(:memo).is_at_most(1000) }
  end

  describe 'include modules' do
    it { is_expected.to be_a(UtilityMethods) }
  end

  describe 'instance methods' do
    describe '#save' do
      subject { described_instance.save }
      it { is_expected.to be_truthy }
    end
  end

  describe 'database encoding' do
    it 'saves 4-byte chars' do
      described_instance.title = 'Card🪪'
      described_instance.memo = 'Memo📝'
      described_instance.save
      card = Card.find(described_instance.id)
      expect(card.title).to eq('Card🪪')
      expect(card.memo).to eq('Memo📝')
    end
  end
end