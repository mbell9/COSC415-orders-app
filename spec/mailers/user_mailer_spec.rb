require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe 'new_order_email' do
    let(:order) { FactoryBot.create(:order) }

    it 'sends a new order email' do
      email = UserMailer.new_order_email(order)

      expect(email.to).to eq([order.restaurant.user.email])
      expect(email.subject).to eq('You received a new order!')
      expect(email.body.encoded).to match(order.id.to_s) # Example of checking body content
    end
  end

  describe 'placed_order_email' do
    let(:order) { FactoryBot.create(:order) }

    it 'sends a placed order email' do
      email = UserMailer.placed_order_email(order)

      expect(email.to).to eq([order.customer.user.email])
      expect(email.subject).to eq('You placed an order successfully!')
      expect(email.body.encoded).to match(order.id.to_s)
    end
  end

  describe 'status_update_email' do
    let(:order) { FactoryBot.create(:order) }
    let(:message) { "Your order status has been updated" }

    it 'sends a status update email' do
      email = UserMailer.status_update_email(order, message)

      expect(email.to).to eq([order.customer.user.email])
      expect(email.subject).to eq(message)
      expect(email.body.encoded).to match(order.id.to_s)
    end
  end
end
