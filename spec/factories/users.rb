# Define a User factory
FactoryBot.define do
  factory :user_customer, class: User do
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    reset_password_token { nil }
    reset_password_sent_at { nil }
    remember_created_at { nil }
    role { 'customer' }
    confirmation_token { nil }
    confirmed_at { Time.now }
    confirmation_sent_at { nil }
    unconfirmed_email { nil }

    trait :unconfirmed do
      confirmed_at { nil }
    end

    # Other user attributes as needed
  end

  factory :user_owner, class: User do
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    reset_password_token { nil }
    reset_password_sent_at { nil }
    remember_created_at { nil }
    role { 'owner' }
    confirmation_token { nil }
    confirmation_sent_at { nil }
    unconfirmed_email { nil }
    confirmed_at { Time.now }


    trait :unconfirmed do
      confirmed_at { nil }
    end

    # Other user attributes as needed
  end
end
