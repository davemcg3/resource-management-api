class SessionsController < ApplicationController
  def login
    @user = User.find_by(name: email)
  end

  def logout

  end

  def user_params
    return ActionController::Parameters.new.permit if params.except(:email, :password).empty?
    params.require(:user).permit(:email, :password, :token)
  end
end