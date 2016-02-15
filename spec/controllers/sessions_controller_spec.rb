require 'rails_helper'

describe "Sessions", type: :request do

  describe '#create' do

    it 'does not allow the user to login if they do not exist in Mixito' do
      post sessions_path, {:username => 'BadUser', :password => 'BadPassword'}

      expect(response).to render_template(:new)
      expect(response.body).to include("You are not authorised to use Mixtio")
    end

  end
end