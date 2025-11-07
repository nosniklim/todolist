require 'rails_helper'

RSpec.describe User, type: :model do
  let(:described_instance) { create(:user) }

  describe 'associations' do
    it { should have_many(:lists).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(20) }
  end

  describe 'include modules' do
    it 'includes Devise' do
      expect(User.ancestors).to include(Devise::Models::DatabaseAuthenticatable)
      expect(User.ancestors).to include(Devise::Models::Registerable)
      expect(User.ancestors).to include(Devise::Models::Recoverable)
      expect(User.ancestors).to include(Devise::Models::Rememberable)
      expect(User.ancestors).to include(Devise::Models::Validatable)
    end
  end

  describe 'instance methods' do
    describe '#save' do
      subject { described_instance.save }
      it { is_expected.to be_truthy }
    end
  end

  describe 'database encoding' do
    it 'saves 4-byte chars' do
      described_instance.name = 'User😊'
      described_instance.save
      expect(User.find(described_instance.id).name).to eq('User😊')
    end
  end
end