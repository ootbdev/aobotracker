class StaticPagesController < ApplicationController
  before_action :verify_session, :except => [:index] 

  def index
    @users = User.all
  end

  def home
  end
end
