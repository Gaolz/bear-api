require "rails_helper"

RSpec.describe "Runs API", type: :request do
  let!(:user) { create(:user, email: "test@example.com", password: "password") }
  let(:token) { JwtService.encode({ user_id: user.id }) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  describe "GET /api/runs" do
    it "returns runs for current user" do
      create(:run, user: user, date: Date.current, distance: 5.0, done: true)
      create(:run, user: user, date: 1.day.ago, distance: 3.0)

      get "/api/runs", headers: headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["runs"].length).to eq(2)
      expect(body["runs"].first["date"]).to be_present
      expect(body["runs"].first["distance"]).to be_present
    end

    it "returns empty array when no runs" do
      get "/api/runs", headers: headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["runs"]).to eq([])
    end

    it "returns 401 without token" do
      get "/api/runs"

      expect(response).to have_http_status(:unauthorized)
    end

    it "does not return other users' runs" do
      other = create(:user, email: "other@example.com")
      create(:run, user: other, date: Date.current)

      get "/api/runs", headers: headers

      body = JSON.parse(response.body)
      expect(body["runs"].length).to eq(0)
    end
  end

  describe "POST /api/runs" do
    it "creates a run" do
      post "/api/runs", params: { run: { date: Date.current, distance: 5.0, done: false } }, headers: headers

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["run"]["distance"]).to eq(5.0)
      expect(body["run"]["done"]).to be false
    end

    it "returns 422 on invalid data" do
      post "/api/runs", params: { run: { date: nil, distance: nil } }, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
      body = JSON.parse(response.body)
      expect(body["errors"]).to be_present
    end

    it "returns 401 without token" do
      post "/api/runs", params: { run: { date: Date.current, distance: 5.0 } }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "PATCH /api/runs/:id" do
    let!(:run) { create(:run, user: user, date: Date.current, distance: 5.0, done: false) }

    it "updates a run" do
      patch "/api/runs/#{run.id}", params: { run: { distance: 10.0, done: true } }, headers: headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["run"]["distance"]).to eq(10.0)
      expect(body["run"]["done"]).to be true
    end

    it "returns 404 for other user's run" do
      other = create(:user, email: "other2@example.com")
      other_run = create(:run, user: other, date: Date.current)

      patch "/api/runs/#{other_run.id}", params: { run: { done: true } }, headers: headers

      expect(response).to have_http_status(:not_found)
    end

    it "returns 401 without token" do
      patch "/api/runs/#{run.id}", params: { run: { done: true } }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /api/runs/:id" do
    let!(:run) { create(:run, user: user, date: Date.current, distance: 5.0) }

    it "deletes a run" do
      expect {
        delete "/api/runs/#{run.id}", headers: headers
      }.to change(Run, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns 404 for other user's run" do
      other = create(:user, email: "other3@example.com")
      other_run = create(:run, user: other, date: Date.current)

      delete "/api/runs/#{other_run.id}", headers: headers

      expect(response).to have_http_status(:not_found)
    end

    it "returns 401 without token" do
      delete "/api/runs/#{run.id}"

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
