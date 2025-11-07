require 'rails_helper'

RSpec.describe List, type: :model do
  let(:described_instance) { create(:list) }
  subject { described_instance }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { should have_many(:cards).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_length_of(:title).is_at_least(1).is_at_most(255) }
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
      described_instance.title = 'List🔖'
      described_instance.save
      expect(List.find(described_instance.id).title).to eq('List🔖')
    end
  end
end