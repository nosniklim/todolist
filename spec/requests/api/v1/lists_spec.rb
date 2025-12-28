require "swagger_helper"

RSpec.describe "Api::V1::Lists", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { User.create!(email: "test@example.com", password: "password", name: "test") }

  before { sign_in user }

  path "/api/v1/lists" do
    get "lists index" do
      tags "Lists"
      produces "application/json"

      response "200", "ok" do
        run_test!
      end
    end
  end

  path "/api/v1/lists/reorder" do
    patch "reorder lists" do
      tags "Lists"
      consumes "application/json"
      produces "application/json"

      parameter name: :payload, in: :body, schema: {
        type: :object,
        required: ["list_ids"],
        properties: {
          list_ids: {
            type: :array,
            items: { type: :integer }
          }
        }
      }

      response "200", "ok" do
        let!(:l1) { user.lists.create!(title: "A", position: 1) }
        let!(:l2) { user.lists.create!(title: "B", position: 2) }
        let!(:l3) { user.lists.create!(title: "C", position: 3) }

        let(:payload) { { list_ids: [l3.id, l1.id, l2.id] } }

        run_test!
      end

      response "422", "invalid" do
        let(:payload) { { list_ids: [999999] } }
        run_test!
      end
    end
  end
end