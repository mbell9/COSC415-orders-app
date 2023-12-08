require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:customer) { FactoryBot.create(:customer) }
  let(:restaurant) { FactoryBot.create(:restaurant) }
  let(:order) { FactoryBot.create(:order, customer: customer, restaurant: restaurant) }
  let(:order_list) { FactoryBot.create_list(:order, 3, customer: customer, restaurant: restaurant)}


  before do
    sign_in customer.user
  end

  describe "GET #index" do

    context "as a customer" do
      it "returns a successful response" do
        get :index
        expect(response).to be_successful
      end

      it "assigns @orders" do
        customer_orders = FactoryBot.create_list(:order, 3, customer: customer)
        get :index
        expect(assigns(:orders)).to match_array(customer_orders)
      end
    end

      context "as a restaurant" do
        before do
          sign_in restaurant.user
        end
        it "returns a successful response" do
          get :index
          expect(response).to be_successful
        end

        it "assigns @orders" do
          restaurant_orders = FactoryBot.create_list(:order, 3, restaurant: restaurant)
          get :index
          expect(assigns(:orders)).to match_array(restaurant_orders)
        end
      end

  end

  describe "GET #show" do
    context "when order exists" do
      it "returns a successful response" do
        get :show, params: { id: order.id }
        expect(response).to be_successful
      end

      it "assigns @order" do
        get :show, params: { id: order.id }
        expect(assigns(:order)).to eq(order)
      end
    end

    context "when order does not exist" do
      it "redirects to home page" do
        get :show, params: { id: 999 }
        expect(response).to redirect_to(home_path)
      end
    end

    context "unauthorized access" do
      let(:other_customer) { FactoryBot.create(:customer) }
      let(:other_restaurant) { FactoryBot.create(:restaurant) }

      it "redirects to home page when unauthorized customer" do
        sign_in other_customer.user
        get :show, params: { id: order.id }
        expect(response).to redirect_to(home_path)
      end

      it "redirects to home page when unauthorized restaurant owner" do
        sign_in other_restaurant.user
        get :show, params: { id: order.id }
        expect(response).to redirect_to(home_path)
      end
    end
  end



  describe "PATCH #update_status" do
    before do
      sign_in restaurant.user
    end

    context "when order exists" do
      context "and status is 'Pending'" do
        it "updates the status to 'Order Taken' and sends an email" do
          order.update(status: "Pending")
          expect(UserMailer).to receive(:status_update_email).with(order, "Your order ##{order.id} has been received by the restaurant!").and_call_original
          patch :update_status, params: { id: order.id }
          order.reload
          expect(order.status).to eq("Order Taken")
          expect(response).to redirect_to(orders_path)
        end
      end

      context "and status is 'Order Taken'" do
        it "updates the status to 'Being Prepared' and sends an email" do
          order.update(status: "Order Taken")
          expect(UserMailer).to receive(:status_update_email).with(order, "Your order ##{order.id} is being prepared!").and_call_original
          patch :update_status, params: { id: order.id }
          order.reload
          expect(order.status).to eq("Being Prepared")
          expect(response).to redirect_to(orders_path)
        end
      end

      context "and status is 'Being Prepared'" do
        it "updates the status to 'Ready for Pickup' and sends an email" do
          order.update(status: "Being Prepared")
          expect(UserMailer).to receive(:status_update_email).with(order, "Your order ##{order.id} is ready for pickup!").and_call_original
          patch :update_status, params: { id: order.id }
          order.reload
          expect(order.status).to eq("Ready for Pickup")
          expect(response).to redirect_to(orders_path)
        end
      end

      context "and status is 'Ready for Pickup'" do
        it "updates the status to 'Picked Up' and sends an email" do
          order.update(status: "Ready for Pickup")
          expect(UserMailer).to receive(:status_update_email).with(order, "Your order ##{order.id} has been picked up!").and_call_original
          patch :update_status, params: { id: order.id }
          order.reload
          expect(order.status).to eq("Picked Up")
          expect(order.end_time).to eq(Time.current.strftime("%Y-%m-%d %H:%M"))
          expect(response).to redirect_to(orders_path)
        end
      end

      # Add similar tests for other status transitions

      context "and status is 'Picked Up'" do
        it "redirects without changing the status" do
          order.update(status: "Picked Up")
          patch :update_status, params: { id: order.id }
          expect(response).to redirect_to(orders_path)
          order.reload
          expect(order.status).to eq("Picked Up")
        end
      end
    end

    context "when order does not exist" do
      it "redirects to home page" do
        patch :update_status, params: { id: 999 }
        expect(response).to redirect_to(home_path)
      end
    end

    context "when status is 'Ready for Pickup'" do
      it "updates the status to 'Picked Up', sets end_time, and transfers funds" do
        order.update(status: "Ready for Pickup")
        expect(UserMailer).to receive(:status_update_email).with(order, "Your order ##{order.id} has been picked up!").and_call_original
        expect(controller).to receive(:transfer_funds_to_restaurant).with(order).and_call_original
        patch :update_status, params: { id: order.id }
        order.reload
        expect(order.status).to eq("Picked Up")
        expect(order.end_time).not_to be_nil
        expect(response).to redirect_to(orders_path)
      end
    end

  end
end
