require "rails_helper"

RSpec.describe "Api::V1::Health", type: :request do
  describe "GET /api/v1/health" do
    it "returns a successful status" do
      get "/api/v1/health"
      expect(response).to have_http_status(:ok)
    end

    it "returns the correct JSON body" do
      get "/api/v1/health"

      json_response = JSON.parse(response.body)

      expect(json_response).to eq({ "status" => "ok" })
    end
  end
end
