class Api::V2::ConsumablesController < Api::V2::ApiController

  def query_params
    params.permit(:barcode)
  end

  def includes
    [
        :consumable_type
    ]
  end

end
