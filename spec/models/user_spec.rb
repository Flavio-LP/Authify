require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'callbacks' do
    it 'generates jti before creation' do
      user = build(:user, jti: nil)
      user.save
      expect(user.jti).to be_present
    end
  end

  describe 'devise modules' do
    it 'has valid factory' do
      expect(build(:user)).to be_valid
    end

    it 'requires password' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end

    it 'requires valid email format' do
      user = build(:user, email: 'invalid')
      expect(user).not_to be_valid
    end
  end
end