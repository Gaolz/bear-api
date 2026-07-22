require "rails_helper"

RSpec.describe "GET /api/me", type: :request do
  let!(:user) { create(:user, email: "test@example.com", password: "password") }
  let(:token) { JwtService.encode({ user_id: user.id }) }

  it "returns current user with valid token" do
    get "/api/me", headers: { "Authorization" => "Bearer #{token}" }

    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body["user"]["email"]).to eq("test@example.com")
  end

  it "returns 401 without token" do
    get "/api/me"

    expect(response).to have_http_status(:unauthorized)
  end

  it "returns 401 with expired token" do
    expired = JwtService.encode({ user_id: user.id }, 1.second.ago)
    get "/api/me", headers: { "Authorization" => "Bearer #{expired}" }

    expect(response).to have_http_status(:unauthorized)
  end
end
