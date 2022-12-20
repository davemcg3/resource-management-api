FactoryBot.define do
  factory :profile do
    organization { Organization.all.sample }
    name { Faker::Name.first_name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    workgroup { Workgroup.all.sample }
    active { true }
  end

  factory :user do
    email { Faker::Internet.email }
    # TODO: encode password, this one can't be used
    password { Faker::Internet.password }
  end
end