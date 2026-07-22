# bear-api — Rails API Backend

## Principles

### 1. Feature Planning
Before writing any code for a new feature, list:
- What endpoints change or get added (method, path, request/response shape)
- What models/services change
- What edge cases exist (auth failure, validation errors, not found, etc.)

### 2. TDD — Tests First
- Write specs before implementation code
- Spec ordering: model validations → service logic → request specs
- Red-green-refactor cycle. Never commit failing tests
- Target: 80%+ line coverage. Run `bundle exec rspec` before every commit

### 3. Ruby Code Style
- Follow Ruby Style Guide (rubocop-rails-omakase)
- 2-space indentation, snake_case for methods/variables
- `describe`/`context`/`it` RSpec structure, one expectation per `it` block
- Use `let` and `before` for DRY setup, factory_bot for test data
- Keep controllers thin — logic in services
- Return early, avoid deep nesting

### 4. API Design
- All endpoints under `namespace :api`
- JSON request/response. Consistent error shape: `{ "error": "message" }`
- JWT token in `Authorization: Bearer <token>` header
- HTTP status codes: 200 success, 201 created, 401 unauthorized, 404 not found, 422 validation error

### 5. Commits
- Small, atomic commits. One logical change per commit
- Conventional commit prefix where helpful: `Add`, `Fix`, `Refactor`
- Commit message explains why, not what

## Stack
- Rails 8.1 API-only
- PostgreSQL, RSpec, Factory Bot, Shoulda Matchers, SimpleCov
- JWT auth with bcrypt
