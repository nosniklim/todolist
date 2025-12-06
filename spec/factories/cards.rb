# == Schema Information
#
# Table name: cards
#
#  id         :bigint           not null, primary key
#  memo       :text(65535)
#  position   :integer          default(0), not null
#  title      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  list_id    :bigint           not null
#
FactoryBot.define do
  factory :card do
    title { 'Sample Card' }
    memo { 'This is a sample card.' }
    position { 1 }
    association :list
  end
end
