class FavouritesController < ApplicationController
  def create
    current_user.favourites.create(:consumable_type_id => params[:consumable_type_id])
    render nothing: true
  end

  def destroy
    favourite = current_user.favourites.find_by(:consumable_type_id => params[:consumable_type_id])
    current_user.favourites.destroy(favourite)
    render nothing: true
  end
end
