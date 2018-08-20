class FavouritesController < ApplicationController
  def create
    current_user.favourites.create(:consumable_type_id => params[:consumable_type_id])
    head :created
  end

  def destroy
    favourite = current_user.favourites.find_by(:consumable_type_id => params[:consumable_type_id])
    current_user.favourites.destroy(favourite)
    head :no_content
  end
end
