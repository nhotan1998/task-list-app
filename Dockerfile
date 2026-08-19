FROM ruby:3.1.2-slim

# Cài đặt các thư viện cần thiết
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    git \
    postgresql-client

WORKDIR /myapp

# Cài đặt gem
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Chạy server
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
