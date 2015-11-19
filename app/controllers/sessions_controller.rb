class SessionsController < ApplicationController

  def create
    authenticate!
    response.header["X-Auth-Token"] = Token.get
    redirect_to :root, notice: "Signed In Successfully"
  end
end
