require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { should have_secure_password }

    it "validates email presence" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it "validates email uniqueness" do
      create(:user, email: "dup@example.com")
      dup = build(:user, email: "dup@example.com")
      expect(dup).not_to be_valid
    end
  end

  describe ".authenticate" do
    it "returns user for valid password" do
      user = create(:user, password: "secret")
      expect(user.authenticate("secret")).to eq(user)
    end

    it "returns false for invalid password" do
      user = create(:user, password: "secret")
      expect(user.authenticate("wrong")).to be false
    end
  end
end
