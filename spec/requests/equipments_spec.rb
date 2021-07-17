require 'rails_helper'

RSpec.describe "Equipments", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/equipments/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/equipments/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
