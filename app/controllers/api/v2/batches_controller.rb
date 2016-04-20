class Api::V2::BatchesController < Api::V2::ApiController

  def includes
    [
        :consumable_type,
        :kitchen,
        :user,
    ]
  end

end
