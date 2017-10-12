require 'rails_helper'

describe Api::V2::ProjectsController, type: :request do

  describe "GET #show" do

    it "should return a serialized project" do
      project = create(:project)
      get api_v2_project_path(project)
      expect(response).to be_success
      project_response = JSON.parse(response.body, symbolize_names: true)

      expect(project_response[:data][:id]).to eql(project.id.to_s)
      expect(project_response[:data][:attributes][:name]).to eql(project.name)
    end

    context "project does not exist" do
      it "should return a 404 with an error message" do
        get api_v2_project_path(:id => 123)
        expect(response.status).to be(404)
        project_response = JSON.parse(response.body, symbolize_names: true)

        expect(project_response[:message]).to include('Couldn\'t find Project with \'id\'=123')
      end
    end

  end
end
