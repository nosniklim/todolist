require 'rails_helper'

RSpec.describe 'MySQL charset & collation' do
  it 'database uses utf8mb4 + utf8mb4_0900_ai_ci' do
    db = ActiveRecord::Base.connection.exec_query(
      'SELECT @@character_set_database AS cs, @@collation_database AS col'
    ).to_a.first
    expect(db['cs']).to eq('utf8mb4')
    expect(db['col']).to eq('utf8mb4_0900_ai_ci')
  end
end
