require 'rails_helper'

RSpec.describe Profile, type: :model do
  # has_one :organization
  # has_many :groups
  # has_and_belongs_to_many :users
  # active by default

  it 'requires the presence of an organization type' do
    subject = Profile.new
    expect(subject).not_to be_valid
    expect(subject.errors.messages[:organization]).to eq ["must exist", "can't be blank"]

    subject.organization = Organization.all.sample
    subject.workgroup = Workgroup.all.sample
    expect(subject).to be_valid
  end

  it 'requires the presence of one group' do
    subject = Profile.new
    expect(subject).not_to be_valid
    expect(subject.errors.messages[:workgroup]).to eq ["must exist", "can't be blank"]

    subject.organization_id = Organization.all.sample.id
    subject.workgroup_id = Workgroup.all.sample.id
    expect(subject).to be_valid
  end

  it 'is set active by default' do
    subject = Profile.new
    expect(subject.active).to be true
  end
end
