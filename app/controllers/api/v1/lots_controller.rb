class Api::V1::LotsController < Api::V1::ApiController

  def includes
    [
        :consumable_type,
        :kitchen
    ]
  end

end
