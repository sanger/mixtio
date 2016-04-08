class Api::V2::IngredientsController < Api::V2::ApiController

  def query_params
    params.permit(:consumable_type_id)
  end

end
