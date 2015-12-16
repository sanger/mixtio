class SessionsController < ApplicationController
  def new
  end

  def create
    if authenticate?(params[:username], params[:password])
      redirect_to root_path, notice: "Signed In Successfully"
    else
      flash[:alert] = "Invalid username or password"
      render :new
    end
  end
end
