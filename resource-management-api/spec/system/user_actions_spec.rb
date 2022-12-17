require 'rails_helper'

RSpec.describe "User actions", type: :request do
  describe 'register' do
    let(:valid_params) do
      {
        user: {
          email: Faker::Internet.email,
          password: Faker::Internet.password
        }
      }
    end

    it 'allows a user to register with an email and password' do
      expect { post '/api/v1/users/register', params: valid_params }.to change(User, :count).by(1)
      expect(response).to have_http_status :created
    end

    it 'does not allow a user to register without an email' do
      valid_params[:user][:email] = nil
      expect { post '/api/v1/users/register', params: valid_params }.not_to change(User, :count)
      expect(response).to have_http_status :unprocessable_entity
    end

    it 'does not allow a user to register without a password' do
      valid_params[:user][:password] = nil
      expect { post '/api/v1/users/register', params: valid_params }.not_to change(User, :count)
      expect(response).to have_http_status :unprocessable_entity
    end
  end

  describe 'forget' do
    before(:each) do
      @user = create(:user)
      @valid_params = {
        user: {
          email: @user.email,
          password: @user.password
        }
      }
    end

    it 'allows an authenticated user to be forgotten' do
      expect { post '/api/v1/users/forget', params: @valid_params }.to change(User, :count).by(-1)
      expect(response).to have_http_status :ok
    end

    it 'does not allow an unauthenticated user to be forgotten' do
      @valid_params[:user][:email] = nil
      expect { post '/api/v1/users/forget', params: @valid_params }.not_to change(User, :count)
      expect(response).to have_http_status :unauthorized
    end
  end
end