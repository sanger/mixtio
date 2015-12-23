class SessionsController < ApplicationController

  def new
  end

  def create
    if authenticate?(params[:username], params[:password])
      redirect_to get_location(root_path), notice: "Signed In Successfully"
    else
      flash[:alert] = "Invalid username or password"
      render :new
    end
  end

  def destroy
    sign_out!
    redirect_to root_path, notice: "Signed Out Successfully"
  end
end
