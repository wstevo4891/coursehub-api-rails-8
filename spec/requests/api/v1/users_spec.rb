require "swagger_helper"

RSpec.describe "Api::V1::Users", type: :request do
  let!(:user) { create(:user) }
  let!(:admin) { create(:user, :admin) }

  let(:access_token) { JsonWebToken.encode(user_id: user.id) }
  let(:admin_token) { JsonWebToken.encode(user_id: admin.id) }

  let(:auth_headers) { { "Authorization" => "Bearer #{access_token}" } }
  let(:admin_auth_headers) { { "Authorization" => "Bearer #{admin_token}" } }

  let(:json_response) { JSON.parse(response.body) }

  describe "GET /api/v1/users/:id" do
    context "when the user exists and is authorized" do
      before { get "/api/v1/users/#{user.id}", headers: auth_headers }

      it "returns a successful status" do
        expect(response).to have_http_status(:ok)
      end

      it "returns the user data" do
        expect(json_response["id"]).to eq(user.id)
        expect(json_response["name"]).to eq(user.name)
        expect(json_response["email"]).to eq(user.email)
        expect(json_response).not_to include("password_digest")
      end
    end

    context "when the user does not exist" do
      it "returns a not found status" do
        get "/api/v1/users/invalid-id", headers: auth_headers
        expect(response).to have_http_status(:not_found)
        expect(json_response["error"]).to eq("User not found")
      end
    end

    context "when the request is unauthorized (no token)" do
      it "returns an unauthorized status" do
        get "/api/v1/users/#{user.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/users" do
    context "with valid parameters" do
      let(:valid_params) do
        { user: attributes_for(:user, name: "Posted User", email: "new@example.com") }
      end

      it "creates a new user" do
        expect {
          post "/api/v1/users", params: valid_params, as: :json
        }.to change { User.count }.by(1)

        expect(User.last.name).to eq("Posted User")
      end

      it "returns a created status" do
        post "/api/v1/users", params: valid_params, as: :json
        expect(response).to have_http_status(:created)
      end

      it "returns the new user data" do
        post "/api/v1/users", params: valid_params, as: :json

        expect(json_response["name"]).to eq("Posted User")
        expect(json_response["email"]).to eq("new@example.com")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          user: {
            name: "",
            email: "invalid-email",
            password: "short",
            password_confirmation: "short"
          }
        }
      end
      let(:errors) { json_response["errors"] }

      it "does not create a new user" do
        expect {
          post "/api/v1/users", params: invalid_params, as: :json
        }.not_to change { User.count }
      end

      it "returns an unprocessable content status" do
        post "/api/v1/users", params: invalid_params, as: :json
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "returns the validation errors" do
        post "/api/v1/users", params: invalid_params, as: :json

        expect(errors).to include("name" => [ "can't be blank" ])
        expect(errors).to include("email" => [ "is invalid" ])
        expect(errors).to include(
          "password" => [ "is too short (minimum is 6 characters)" ]
        )
      end
    end
  end

  path "/api/v1/users/{id}" do
    parameter name: :id, in: :path, type: :string, description: "User ID"

    get "Retrieves a user" do
      tags "Users"
      produces "application/json"

      response "200", "user found" do
        schema  type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  email: { type: :string },
                  is_admin: { type: :boolean },
                  created_at: { type: :string, format: "date-time" },
                  updated_at: { type: :string, format: "date-time" }
                },
                required: [ "id", "name", "email", "is_admin" ]

        let(:id) { user.id }
        let(:Authorization) { "Bearer #{access_token}" }

        run_test!
      end

      response "404", "user not found" do
        schema type: :object,
               properties: {
                error: { type: :string }
               }

        let(:id) { "invalid-id" }
        let(:Authorization) { "Bearer #{access_token}" }

        run_test!
      end
    end
  end
end
