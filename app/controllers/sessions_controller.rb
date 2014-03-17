class SessionsController < ApplicationController
  def create
    cookies[:user_id] = params["user_id"]
  end

  def destroy
  end
end
