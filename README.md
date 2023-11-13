# COSC415-orders-app
## Overview
This application is designed for handling orders within a restaurant setting. It includes features for browsing menu items, managing a shopping cart, and customer profiles.

## Features
- **Browse**: Customers can view and select from a list of restaurants and menu items.
- **Cart Management**: Functionality for adding items to a cart and managing them.
- **Customer Profiles**: Customers can view and edit their profiles.
- **Restaurant Management**: Restaurants can manage their menu items and reviews.

## Technical Details
- **Ruby Version**: Specified in `.ruby-version`.
- **System Dependencies**: Defined in `Gemfile` and `Gemfile.lock`.
- **Database**: Uses ActiveRecord with migrations to manage the database schema.
- **Routing**: Custom routes for restaurant browsing and cart management.

## Setup
- **Docker**: Container setup is available via `Dockerfile`.
- **Database Initialization**: Seed data can be loaded with `db/seeds.rb`.
- **Testing**: Test suite written with RSpec, located in the `spec` directory.

## Usage
- Start the server with Docker or Rails command.
- Access the application through the root route to browse restaurants.
- Use customer routes to manage profiles and cart routes for cart items.

## Contributing
- Check out the latest main to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
- Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
- Fork the project.
- Start a feature/bugfix branch.
- Commit and push until you are happy with your contribution.
- Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.

## Additional Information
- **Health Check Route**: `GET /up` for application health status.
- **Active Storage**: Integrated for file uploads.

## Repository Structure
- **Controllers**: Business logic for the application features.
- **Models**: Data layer with ActiveRecord models.
- **Views**: ERB templates for the user interface.
- **Routes**: Defined in `config/routes.rb` for URL management.
