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
class List < ApplicationRecord
  belongs_to :user
  has_many :cards, dependent: :destroy
  validates :title, length: { in: 1..255 }
  include UtilityMethods
end
