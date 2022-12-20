require 'rails_helper'

RSpec.describe "Profile actions", type: :request do
  describe 'index' do
    it 'returns a list of all profiles' do
      create(:profile)
      create(:profile)
      get '/api/v1/profiles/index'
      expect( JSON.parse(response.body)["profiles"].count ).to eq 2
      expect(response).to have_http_status :ok
    end
  end

  describe 'create' do
    let(:valid_params) {
      {
        profile: {
          organization_id: Organization.first.id,
          name: Faker::Name.first_name,
          email: Faker::Internet.email,
          phone: Faker::PhoneNumber.phone_number,
          workgroup_id: Workgroup.first.id,
          active: true,
        }
      }
    }

    it 'creates a profile if valid params sent' do
      expect{ post '/api/v1/profile/create', params: valid_params }.to change(Profile, :count).by(1)
      expect(response).to have_http_status :created
    end

    it 'does not create a profile without an organization' do
      invalid_params = valid_params.clone
      invalid_params[:profile][:organization_id] = nil
      expect{ post '/api/v1/profile/create', params: invalid_params }.not_to change(Profile, :count)
      expect( JSON.parse(response.body)["error"] ).to eq "Unable to create profile: Organization must exist, Organization can't be blank"
      expect(response).to have_http_status :unprocessable_entity
    end

    it 'does not create a profile without a workgroup' do
      invalid_params = valid_params.clone
      invalid_params[:profile][:workgroup_id] = nil
      expect{ post '/api/v1/profile/create', params: invalid_params }.not_to change(Profile, :count)
      expect( JSON.parse(response.body)["error"] ).to eq "Unable to create profile: Workgroup must exist, Workgroup can't be blank"
      expect(response).to have_http_status :unprocessable_entity
    end
  end

  describe 'show' do
    before do
      @profile = create(:profile)
    end

    it "returns a profile if a profile is found" do
      expected_response = {
        "profile" => {
          "active" => true,
          "created_at" => @profile.created_at.iso8601(3),
          "email" => @profile.email,
          "id" => @profile.id,
          "name" => @profile.name,
          "organization_id" => @profile.organization.id,
          "phone" => @profile.phone ,
          "updated_at" => @profile.updated_at.iso8601(3),
          "workgroup_id" => @profile.workgroup.id,
        }
      }
      get "/api/v1/profile/#{@profile.id}/show"
      expect( JSON.parse(response.body) ).to eq expected_response
      expect(response).to have_http_status :ok
    end

    it "returns an error if no profile is found" do
      expected_response = { "error" => "Unable to find matching profile" }
      get "/api/v1/profile/#{@profile.id + 1}/show"
      expect( JSON.parse(response.body) ).to eq expected_response
      expect(response).to have_http_status :not_found
    end
  end

  describe 'update' do
    before do
      @profile = create(:profile)
    end

    it "returns a 404 if the wrong profile id is passed" do
      updated_name = Faker::Name.first_name
      invalid_params = { profile: { name: updated_name } }
      expected_response = { "error" => "Unable to find matching profile" }
      put "/api/v1/profile/#{@profile.id + 1}/update", params: invalid_params
      expect( JSON.parse(response.body) ).to eq expected_response
      expect(response).to have_http_status :not_found
    end

    it "updates the record if valid params are passed" do
      updated_name = Faker::Name.first_name
      valid_params = { profile: { name: updated_name } }
      patch "/api/v1/profile/#{@profile.id}/update", params: valid_params
      @profile.reload
      expected_response = {
        "profile" => {
          "active" => true,
          "created_at" => @profile.created_at.iso8601(3),
          "email" => @profile.email,
          "id" => @profile.id,
          "name" => updated_name,
          "organization_id" => @profile.organization.id,
          "phone" => @profile.phone ,
          "updated_at" => @profile.updated_at.iso8601(3),
          "workgroup_id" => @profile.workgroup.id,
        }
      }
      expect( JSON.parse(response.body) ).to eq expected_response
      expect(response).to have_http_status :ok
    end

    it "does not update the record if the update will make it invalid" do
      invalid_params = { profile: { organization_id: nil } }
      expected_response = { "error" => "Unable to edit profile: Organization must exist, Organization can't be blank" }
      patch "/api/v1/profile/#{@profile.id}/update", params: invalid_params
      expect( JSON.parse(response.body) ).to eq expected_response
      expect(response).to have_http_status :unprocessable_entity
    end
  end

  describe 'destroy' do
    before do
      @profile = create(:profile)
    end

    it "returns a 404 when trying to destroy a non-existent record" do
      expected_response = { "error" => "Unable to find matching profile" }
      delete "/api/v1/profile/#{@profile.id + 1}/destroy"
      expect( JSON.parse(response.body) ).to eq expected_response
      expect(response).to have_http_status :not_found
    end

    it "destroys a record on demand" do
      expected_response = { "message" => "Profile destroyed" }
      delete "/api/v1/profile/#{@profile.id}/destroy"
      expect( JSON.parse(response.body) ).to eq expected_response
      expect(response).to have_http_status :ok
    end
  end
end
