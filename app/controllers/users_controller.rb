class UsersController < ApplicationController

  before_action :users, only: [:index]

  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: "User successfully created"
    else
      render :new
    end
  end

  def edit
    @user =current_resource
  end

  def update
    @user = current_resource
    if @user.update_attributes(user_params)
      redirect_to users_path, notice: "User successfully updated"
    else
      render :edit
    end
  end

  def users
    @users ||= User.all
  end

  helper_method :users

protected

  def user_params
    params.require(:user).permit(:username, :team_id, :status, :type)
  end

  def current_resource
    @current_resource ||= User.find(params[:id]) if params[:id]
  end

end
