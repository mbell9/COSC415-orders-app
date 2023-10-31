require 'rails_helper'

RSpec.describe "Browse Restaurants", type: :request do

  describe "GET /restaurants" do
    it "gets a list of restaurants" do
      restaurant1 = instance_double("Restaurant", id: 1, name: "Royal Indian Grill")
      restaurant2 = instance_double("Restaurant", id: 2, name: "Main Moon")

      allow(Restaurant).to receive(:all).and_return([restaurant1, restaurant2])

      get restaurants_path
      expect(response).to have_http_status(200)
      expect(response.body).to include("Royal Indian Grill")
      expect(response.body).to include("Main Moon")
    end
  end

  describe "GET /restaurants/:id" do
    it "gets an individual restaurant" do
      restaurant = instance_double("Restaurant", id: 1, name: "Royal Indian Grill")

      allow(Restaurant).to receive(:find).with("1").and_return(restaurant)

      get restaurant_path(restaurant)
      expect(response).to have_http_status(200)
      expect(response.body).to include("Royal Indian Grill")
    end
  end

end