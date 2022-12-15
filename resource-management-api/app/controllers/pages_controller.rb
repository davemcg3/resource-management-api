class PagesController < ApplicationController
  def home
    render json: {hello: :world}
  end

  def ping
    render json: {ping: :pong}
  end
end
