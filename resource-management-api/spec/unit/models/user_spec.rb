require 'rails_helper'

RSpec.describe User, type: :model do
  it 'validates presence of email and password' do
    user = User.new
    expect(user).not_to be_valid
    expect(user.errors.messages[:email]).to eq ["can't be blank"]
    expect(user.errors.messages[:password]).to eq ["can't be blank"]

    user.email = Faker::Internet.email
    expect(user).not_to be_valid
    expect(user.errors.messages[:email]).to eq []
    expect(user.errors.messages[:password]).to eq ["can't be blank"]

    user.password = Faker::Internet.password
    expect(user).to be_valid
    expect(user.errors.messages[:email]).to eq []
    expect(user.errors.messages[:password]).to eq []

    user.email = nil
    expect(user).not_to be_valid
    expect(user.errors.messages[:email]).to eq ["can't be blank"]
    expect(user.errors.messages[:password]).to eq []
  end

  it 'validates a unique email' do
    user = create(:user)
    user2 = User.new(email: user.email, password: Faker::Internet.password)
    expect(user2).not_to be_valid
    expect(user2.errors.messages[:email]).to eq ['has already been taken']
  end
end