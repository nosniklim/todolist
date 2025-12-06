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
class Card < ApplicationRecord
  belongs_to :list
  validates :title, length: { in: 1..255 }
  validates :memo,  length: { maximum: 1000 }
  include UtilityMethods
end
