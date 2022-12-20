require 'rails_helper'

module Api
  module V1
    describe UsersController, type: :controller do
      describe "Register user" do
        it 'return a successful registration if user saved with valid credentials' do
          expect { post :register, params: { user: { email: Faker::Internet.email, password: Faker::Internet.password } } }.to change(User, :count).by(1)
          expect(response).to have_http_status :created
        end

        # I think this is a bug but something I observed writing tests
        # This throws a 400 Bad Request for Parameter Missing, which might be right
        # TODO: Fix potential bug
        it 'throws exception if parameters not filled in' do
          expect { post :register, params: { user: { } } }.to raise_error ActionController::ParameterMissing
        end

        it 'should error if not able to save user' do
          params = [
            { email: nil, password: nil }, # no email or password provided
            { email: Faker::Internet.email }, # no password provided
            { password: Faker::Internet.password }, # no email provided
          ]
          params.each do |param|
            expect { post :register, params: { user: param } }.not_to change(User, :count)
            expect(response).to have_http_status :unprocessable_entity
          end
        end
      end

      describe "Forget User" do
        it 'does not allow an unauthenticated user to be forgotten' do
          expect { post :forget, params: { user: { email: nil } } }.not_to change(User, :count)
          expect(response).to have_http_status :unauthorized
        end

        it 'allows an authenticated user to be forgotten' do
          user = create(:user)
          expect { post :forget, params: { user: { email: user.email, password: user.password } } }.to change(User, :count).by(-1)
          expect(response).to have_http_status :ok
        end
      end
    end
  end
end
