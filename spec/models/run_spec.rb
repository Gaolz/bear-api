require "rails_helper"

RSpec.describe Run, type: :model do
  describe "validations" do
    subject { build(:run) }

    it { should belong_to(:user) }
    it { should validate_presence_of(:date) }
    it { should validate_numericality_of(:distance).is_greater_than_or_equal_to(0) }

    it "validates date uniqueness per user" do
      user = create(:user)
      create(:run, user: user, date: Date.current)
      dup = build(:run, user: user, date: Date.current)
      expect(dup).not_to be_valid
    end

    it "allows same date for different users" do
      user1 = create(:user, email: "a@example.com")
      user2 = create(:user, email: "b@example.com")
      create(:run, user: user1, date: Date.current)
      run = build(:run, user: user2, date: Date.current)
      expect(run).to be_valid
    end
  end

  describe "scopes" do
    it "orders by date descending" do
      user = create(:user)
      create(:run, user: user, date: 3.days.ago)
      recent = create(:run, user: user, date: 1.day.ago)
      expect(user.runs.order(date: :desc).first).to eq(recent)
    end
  end
end
