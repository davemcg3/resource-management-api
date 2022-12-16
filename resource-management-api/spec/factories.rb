FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    # TODO: encode password, this one can't be used
    password { Faker::Internet.password }
  end
end