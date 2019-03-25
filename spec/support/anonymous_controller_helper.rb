test_routes = Proc.new do
  get '/anonymous' => 'anonymous#index'
end

Rails.application.routes.send(:eval_block, test_routes)

class AnonymousController < ActionController::Base

  include Authentication::ControllerConcern

  before_action :store_location
  before_action :authenticate!

  def session
    if request
      request.session
    else
      @session ||= {}
    end
  end

  def index
    render plain: "success!"
  end

end