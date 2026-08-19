# TaskList

A Rails-based task management application built with Docker, supporting user authentication, task CRUD, file uploads, filters, and search.

## Project Overview

This application allows users to:

- Create tasks
- View all tasks
- Open a single task
- Mark tasks as completed or incomplete
- Edit task title, description, and due date
- Delete tasks
- Upload supporting files to each task
- Search tasks by keyword
- Filter tasks by status
- Keep task data user-specific through authentication

## Tech Stack

- Ruby 3.1.2
- Ruby on Rails 7.1.x
- PostgreSQL 15
- Docker / Docker Compose
- Bootstrap 5
- Active Storage for file uploads

## Default Demo Account

A default seeded user is available for quick testing:

- Email: test@example.com
- Password: password123

## Requirements

- Docker
- Docker Compose

## Quick Start

1. Clone the repository:

   ```bash
   git clone <your-repository-url>
   cd task_list
   ```

2. Create your local environment file from the sample:

   ```bash
   cp .env.example .env
   ```

   Review the values in `.env` and adjust them if needed. The default Docker setup is already configured for local development.

3. Build and start the app with Docker Compose:

   ```bash
   docker compose up --build
   ```

4. Wait for the containers to start, then run database setup:

   ```bash
   docker compose exec web bundle exec rails db:create
   docker compose exec web bundle exec rails db:migrate
   docker compose exec web bundle exec rails db:seed
   ```

5. Open the app in a browser:

   ```text
   http://localhost:3000
   ```

## Environment Variables

The project uses a `.env` file for local configuration. A sample template is included in `.env.example`.

Example values:

```env
RAILS_ENV=development
DB_HOST=db
DB_PORT=5432
POSTGRES_DB=task_list_development
POSTGRES_USER=postgres
POSTGRES_PASSWORD=password
TASK_LIST_DATABASE_PASSWORD=password
SECRET_KEY_BASE=replace_with_your_secure_secret
```

Copy the sample file before running the app:

```bash
cp .env.example .env
```

For local non-Docker development, change `DB_HOST` to `localhost` when needed.

## Login

After starting the app, log in with the demo account:

- Email: test@example.com
- Password: password123

## Running Tests

To run the relevant test suite:

```bash
docker compose exec web bash -lc "RAILS_ENV=test bundle exec rails db:environment:set RAILS_ENV=test && RAILS_ENV=test bundle exec rails test test/controllers/tasks_controller_test.rb test/models/task_test.rb"
```

## Common Commands

Start the containers:

```bash
docker compose up
```

Stop the containers:

```bash
docker compose down
```

Rebuild after dependency changes:

```bash
docker compose up --build
```

View logs:

```bash
docker compose logs -f web
```

## File Upload Limit

Each uploaded file must be 10MB or smaller.

## Notes

- The app uses Docker for a Rails + PostgreSQL development environment.
- Authentication is session-based.
- Tasks are scoped to the logged-in user.
- The project includes search and status filtering for the task list page.

## Project Submission Notes

This project was implemented as a Rails task manager with Docker support and follows the requested requirements for task management, file upload support, and user-specific task access.
