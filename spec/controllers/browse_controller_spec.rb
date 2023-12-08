require 'rails_helper'

describe BrowseController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let(:restaurant) { create(:restaurant) }

    it 'returns a successful response' do
      get :show, params: { id: restaurant.id }
      expect(response).to be_successful
    end
  end
end
