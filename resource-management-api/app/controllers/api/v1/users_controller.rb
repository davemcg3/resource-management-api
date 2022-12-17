class Api::V1::UsersController < ApplicationController
  def register
    @errors = ''
    @user = User.create(user_params)
    if @user.id.present?
      render json: { user: @user }, status: :created
    else
      render json: { error: "Unable to create user: #{@user.errors.full_messages_for(:email).join(', ')}" }, status: :unprocessable_entity
    end
  end

  # for GDPR purposes, should require authentication
  def forget
    if authenticate_user
      # TODO: Add rule checking for permission to destroy
      # TODO: accept a user parameter too
      if @user.destroy
        render json: { user: 'User deleted' }, status: :ok
      else
        # not sure how to test this code path, maybe with a freeze?
        render json: { error: 'Unable to delete user' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  # verify user credentials
  def authenticate_user
    # TODO Add token authentication method checking
    # TODO: @user assignment should be in a set_user function
    @user = User.find_by(email: user_params[:email])
    return true if (@user && @user.authenticate(user_params[:password]))
    false
  end

  def user_params
    return ActionController::Parameters.new.permit if params.except(:email, :password).empty?
    params.require(:user).permit(:email, :password)
  end
end