require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:enrollments) }

    it { should have_many(:courses).through(:enrollments) }

    it { should have_many(:refresh_tokens).dependent(:destroy) }

    describe "#user_setting" do
      let(:user) { create(:user) }
      let(:settings_attributes) do
        {
          theme: "dark",
          language: "en",
          notifications: { email: true, sms: false } }
      end

      it "returns nil if no settings exist" do
        expect(user.user_setting).to be_nil
      end

      it "creates and returns user settings when assigned" do
        user.user_setting = settings_attributes
        user.save!

        expect(user.user_setting).not_to be_nil
        expect(user.user_setting.theme).to eq("dark")
        expect(user.user_setting.language).to eq("en")
        expect(user.user_setting.notifications).to eq({ "email" => true, "sms" => false })
      end

      it "raises an error if invalid settings are provided" do
        expect {
          user.user_setting = { invalid_attr: "value" }
        }.to raise_error(Mongoid::Errors::UnknownAttribute)
      end
    end
  end

  describe "validations" do
    subject { build(:user) }
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a name" do
      subject.name = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:name]).to include("can't be blank")
    end

    it "is not valid without an email" do
      subject.email = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:email]).to include("can't be blank")
    end

    it "is not valid with an invalid email format" do
      subject.email = "invalid-email"
      expect(subject).not_to be_valid
      expect(subject.errors[:email]).to include("is invalid")
    end

    it "is not valid with a duplicate email (case-insensitive)" do
      create(:user, email: "test@example.com")
      subject.email = "test@example.com"

      expect(subject).not_to be_valid
      expect(subject.errors[:email]).to include("has already been taken")
    end

    it "is not valid without a password (on creation)" do
      invalid_user = build(:user, password: nil)

      expect(invalid_user).not_to be_valid
      expect(invalid_user.errors[:password]).to include("can't be blank")
    end

    it "is not valid if password confirmation does not match" do
      subject.password_confirmation = "differentpassword"

      expect(subject).not_to be_valid
      expect(subject.errors[:password_confirmation]).to include("doesn't match Password")
    end

    it "is not valid if password is too short" do
      subject.password = "short"
      subject.password_confirmation = "short"

      expect(subject).not_to be_valid
      expect(subject.errors[:password]).to include("is too short (minimum is 6 characters)")
    end
  end

  describe "#admin_status" do
    it "returns 'Administrator' if user is an admin" do
      admin_user = build(:user, is_admin: true)
      expect(admin_user.admin_status).to eq("Administrator")
    end

    it "returns 'User' if user is not an admin" do
      regular_user = build(:user, is_admin: false)
      expect(regular_user.admin_status).to eq("User")
    end
  end
end
