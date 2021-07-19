require 'rails_helper'

RSpec.describe "Outfits", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/outfits/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/outfits/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
