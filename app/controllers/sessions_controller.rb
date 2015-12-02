class SessionsController < ApplicationController

  def create
    authenticate!
    redirect_to :root, notice: "Signed In Successfully"
  end
end
