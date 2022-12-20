require 'rails_helper'

module Api
  module V1
    describe ProfilesController, type: :controller do
      describe "index" do
        it 'returns the complete list of profiles' do
          create(:profile)
          create(:profile)
          get :index
          # will need to update when we put some in seeds
          expect( JSON.parse(response.body)["profiles"].count ).to eq 2
        end
      end

      describe "create" do
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
          expect{ post :create, params: valid_params }.to change(Profile, :count).by(1)
          expect(response).to have_http_status :created
        end

        it 'does not create a profile without an organization' do
          invalid_params = valid_params.clone
          invalid_params[:profile][:organization_id] = nil
          expect{ post :create, params: invalid_params }.not_to change(Profile, :count)
          expect( JSON.parse(response.body)["error"] ).to eq "Unable to create profile: Organization must exist, Organization can't be blank"
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'does not create a profile without a workgroup' do
          invalid_params = valid_params.clone
          invalid_params[:profile][:workgroup_id] = nil
          expect{ post :create, params: invalid_params }.not_to change(Profile, :count)
          expect( JSON.parse(response.body)["error"] ).to eq "Unable to create profile: Workgroup must exist, Workgroup can't be blank"
          expect(response).to have_http_status :unprocessable_entity
        end
      end

      describe "show" do
        before do
          @profile = create(:profile)
        end

        it "returns a profile if a profile is found" do
          valid_params = { id: @profile.id }
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
          get :show, params: valid_params
          expect( JSON.parse(response.body) ).to eq expected_response
          expect(response).to have_http_status :ok
        end

        it "returns an error if no profile is found" do
          invalid_params = { id: @profile.id + 1 }
          expected_response = { "error" => "Unable to find matching profile" }
          get :show, params: invalid_params
          expect( JSON.parse(response.body) ).to eq expected_response
          expect(response).to have_http_status :not_found
        end
      end

      describe "update" do
        before do
          @profile = create(:profile)
        end

        it "returns a 404 if the wrong profile id is passed" do
          updated_name = Faker::Name.first_name
          invalid_params = { profile: { name: updated_name }, id: @profile.id + 1 }
          expected_response = { "error" => "Unable to find matching profile" }
          put :update, params: invalid_params
          expect( JSON.parse(response.body) ).to eq expected_response
          expect(response).to have_http_status :not_found
        end

        it "updates the record if valid params are passed" do
          updated_name = Faker::Name.first_name
          valid_params = { profile: { name: updated_name }, id: @profile.id }
          patch :update, params: valid_params
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
          invalid_params = { profile: { organization_id: nil }, id: @profile.id }
          expected_response = { "error" => "Unable to edit profile: Organization must exist, Organization can't be blank" }
          patch :update, params: invalid_params
          expect( JSON.parse(response.body) ).to eq expected_response
          expect(response).to have_http_status :unprocessable_entity
        end
      end

      describe "destroy" do
        before do
          @profile = create(:profile)
        end

        it "returns a 404 when trying to destroy a non-existent record" do
          invalid_params = { id: @profile.id + 1 }
          expected_response = { "error" => "Unable to find matching profile" }
          delete :destroy, params: invalid_params
          expect( JSON.parse(response.body) ).to eq expected_response
          expect(response).to have_http_status :not_found
        end

        it "destroys a record on demand" do
          valid_params = { id: @profile.id }
          expected_response = { "message" => "Profile destroyed" }
          delete :destroy, params: valid_params
          expect( JSON.parse(response.body) ).to eq expected_response
          expect(response).to have_http_status :ok
        end
      end
    end
  end
end

