require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /main" do
    it "returns http success" do
      get "/home/main"
      expect(response).to have_http_status(:success)
    end
  end

end
