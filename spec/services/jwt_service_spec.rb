require "rails_helper"

RSpec.describe JwtService do
  let(:payload) { { user_id: 1 } }

  describe ".encode" do
    it "returns a JWT token string" do
      token = described_class.encode(payload)
      expect(token).to be_a(String)
      expect(token.split(".").length).to eq(3)
    end

    it "includes an expiration claim" do
      token = described_class.encode(payload, 1.hour.from_now)
      decoded = described_class.decode(token)
      expect(decoded[:exp]).to be_present
    end
  end

  describe ".decode" do
    it "decodes a valid token" do
      token = described_class.encode(payload)
      decoded = described_class.decode(token)
      expect(decoded[:user_id]).to eq(1)
    end

    it "returns nil for expired token" do
      token = described_class.encode(payload, 1.second.ago)
      expect(described_class.decode(token)).to be_nil
    end

    it "returns nil for garbled token" do
      expect(described_class.decode("not.a.token")).to be_nil
    end
  end
end
