class Api::V1::ConsumablesController < Api::V1::ApiController

  def query_params
    params.permit(:barcode)
  end

  def includes
    [
        :consumable_type
    ]
  end

end
