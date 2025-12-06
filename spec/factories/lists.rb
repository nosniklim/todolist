# == Schema Information
#
# Table name: lists
#
#  id         :bigint           not null, primary key
#  position   :integer          default(0), not null
#  title      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
FactoryBot.define do
  factory :list do
    title { 'Sample List' }
    position { 1 }
    association :user
  end
end
