class Api::V2::LotsController < Api::V2::ApiController

  def includes
    [
        :consumable_type,
        :kitchen
    ]
  end

end
