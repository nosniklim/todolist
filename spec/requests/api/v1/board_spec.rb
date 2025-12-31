require 'swagger_helper'

RSpec.describe 'Api::V1::Board', type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { User.create!(email: 'test@example.com', password: 'password', name: 'test') }

  before { sign_in user }

  path '/api/v1/board' do
    get 'Get board collection (lists with cards)' do
      tags 'Board'
      produces 'application/json'

      response '200', 'board data' do
        schema type: :object,
               properties: {
                 lists: {
                   type: :array,
                   items: {
                     type: :object,
                     required: %w[id title position cards],
                     properties: {
                       id: { type: :integer },
                       title: { type: :string },
                       position: { type: :integer },
                       cards: {
                         type: :array,
                         items: {
                           type: :object,
                           required: %w[id title memo position],
                           properties: {
                             id: { type: :integer },
                             title: { type: :string },
                             memo: { type: :string, nullable: true },
                             position: { type: :integer }
                           }
                         }
                       }
                     }
                   }
                 }
               }

        run_test!
      end

      response '401', 'unauthorized' do
        before { sign_out user }
        run_test!
      end
    end
  end
end
