class Api::V1::ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, :with => :error_render_method

  def index
    @profiles = Profile.joins(:organization, :workgroup).all.pluck(:id, 'organizations.name', :name, :email, :phone, 'workgroups.name', :active)
    render json: { profiles: @profiles }, status: :ok
  end

  def create
    @profile = Profile.new(profile_params)
    if @profile.save
      render json: { profile: @profile }, status: :created
    else
      error_messages = ""
      @profile.errors.full_messages.each_with_index do |message, index|
        error_messages += ", " if index > 0
        error_messages += message
      end
      render json: {
        error: "Unable to create profile: #{error_messages}" }, status: :unprocessable_entity
    end
  end

  def show
    if @profile.id
      render json: { profile: @profile }, status: :ok
    else
      render json: { error: "Unable to find matching profile" }, status: :not_found
    end
  end

  def update
    Rails.logger.debug profile_params.inspect
    Rails.logger.debug profile_params.inspect
    if @profile.update(profile_params)
      render json: { profile: @profile }, status: :ok
    else
      error_messages = ""
      @profile.errors.full_messages.each_with_index do |message, index|
        error_messages += ", " if index > 0
        error_messages += message
      end
      render json: { error: "Unable to edit profile: #{error_messages}" }, status: :unprocessable_entity
    end
  end

  def destroy
    if @profile.destroy
      render json: { message: "Profile destroyed" }, status: :ok
    else
      error_messages = ""
      @profile.errors.full_messages.each_with_index do |message, index|
        error_messages += ", " if index > 0
        error_messages += message
      end
      render json: { error: "Unable to delete profile: #{error_messages}" }, status: :unprocessable_entity
    end
  end

  private

    def set_profile
      @profile = Profile.find(params[:id])
    end

  def error_render_method
    render json: { error: "Unable to find matching profile" }, status: :not_found
  end

  def profile_params
      return ActionController::Parameters.new.permit if params.except(:email, :password).empty?
      params.require(:profile).permit(:id, :organization_id, :name, :email, :phone, :workgroup_id, :active)
    end
end
