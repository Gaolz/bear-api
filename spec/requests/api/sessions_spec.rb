require "rails_helper"

RSpec.describe "POST /api/login", type: :request do
  let!(:user) { create(:user, email: "test@example.com", password: "password") }

  it "returns token and user on valid credentials" do
    post "/api/login", params: { email: "test@example.com", password: "password" }

    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body["token"]).to be_present
    expect(body["user"]["email"]).to eq("test@example.com")
  end

  it "returns 401 on invalid password" do
    post "/api/login", params: { email: "test@example.com", password: "wrong" }

    expect(response).to have_http_status(:unauthorized)
    body = JSON.parse(response.body)
    expect(body["error"]).to eq("Invalid email or password")
  end

  it "returns 401 on unknown email" do
    post "/api/login", params: { email: "nobody@example.com", password: "password" }

    expect(response).to have_http_status(:unauthorized)
    body = JSON.parse(response.body)
    expect(body["error"]).to eq("Invalid email or password")
  end
end
