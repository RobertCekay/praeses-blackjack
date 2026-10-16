# Blackjack [![Tests](https://github.com/RobertCekay/praeses-blackjack/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/RobertCekay/praeses-blackjack/actions/workflows/tests.yml))

This is a simple Blackjack web game. Made with Rails 8 and Ruby 3.4

## Prerequisites

Ensure you have the following system dependencies installed:

* **Ruby:** `3.4.3` (managed via `rbenv` or `rvm`)
* **Rails:** `8.0.0`

##  Getting Started

Follow these steps to set up the application locally.

### 1. Clone the Repository
```bash
git clone https://github.com/RobertCekay/praeses-blackjack.git
cd praeses-blackjack
```

### 2. Install Dependencies
Install both Ruby gems and JavaScript packages:
```bash
bundle install
```

### 4. Database Setup
Create, migrate, and seed the local database:
```bash
bin/rails db:prepare
```

### 5. Start the Application
Run the application locally using `bin/dev`.
```bash
bin/dev
```
Open your browser and navigate to [http://localhost:3000](http://localhost:3000).

## Running Tests

We use **RSpec** for testing. Run the entire test suite using:

```bash
# Run all tests
bundle exec rspec

# Run a specific test file
bundle exec rspec spec/models/game_spec.rb
```

To check code quality and formatting compliance, run **RuboCop**:
```bash
bundle exec rubocop
```