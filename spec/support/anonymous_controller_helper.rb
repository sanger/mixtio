test_routes = Proc.new do
  get '/anonymous' => 'anonymous#index'
end

Rails.application.routes.send(:eval_block, test_routes)

class AnonymousController < ActionController::Base

  include Authentication::ControllerConcern

  before_filter :store_location
  before_filter :authenticate!

  def session
    if request
      request.session
    else
      @session ||= {}
    end
  end

  def index
    render text: "success!"
  end

end