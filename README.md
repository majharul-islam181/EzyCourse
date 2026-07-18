# EzyCourse

EzyCourse is a Flutter application structured around feature-first clean architecture. The current implementation focuses on the authentication feature, app session management, routing guards, dependency injection, theming, and network setup.

## Architecture

The app follows a clean architecture flow:

```text
presentation -> domain -> data
```

Feature code is organized by responsibility:

```text
lib/features/auth/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── bloc/
│   ├── page/
│   └── widget/
└── di/
```

Core/shared app infrastructure lives under:

```text
lib/core/
├── blocs/
├── di/
├── errors/
├── network/
├── storage/
├── theme/
├── utils/
└── widgets/
```

## Auth Feature

The auth feature currently supports email/password login.

Login API:

```http
POST {{BASE_URL}}/student/auth/login
```

Request body:

```json
{
  "email": "user@example.com",
  "password": "password123",
  "app_fcm_token": "optional_fcm_token"
}
```

Successful response:

```json
{
  "type": "bearer",
  "token": "token_value"
}
```

### Auth Flow

```text
LoginPage
  -> LoginBloc
  -> LoginUseCase
  -> AuthRepository
  -> AuthRepositoryImpl
  -> AuthRemoteDataSource
  -> DioClient
  -> AuthSessionModel
  -> LoginBloc success
  -> AuthSessionBloc authenticated
  -> GoRouter redirects to coaching list
```

### Layer Responsibilities

`domain/entities/auth_session.dart`

Defines the pure business entity:

```text
type
token
```

`data/models/auth_session_model.dart`

Parses the API response and converts it to an auth session model.

`domain/repositories/auth_repository.dart`

Defines the auth contract. The domain layer knows what auth can do, but not how the API works.

`domain/usecases/login_usecase.dart`

Contains the login business action and calls the repository contract.

`data/datasources/auth_remote_data_source.dart`

Performs the actual login API request using `DioClient`.

`data/repositories/auth_repository_impl.dart`

Maps data source results and exceptions into `Either<Failure, AuthSession>`.

`presentation/bloc/login_bloc.dart`

Handles login form state:

```text
initial
loading
success
failure
```

`presentation/page/login_page.dart`

Provides page-level blocs, listens to login state, shows success/error feedback, and passes UI state to the form widget.

`presentation/widget/login_form.dart`

Contains the login UI:

- email field
- password field
- password visibility toggle
- login button
- inline error message
- loading indicator

## Token And Session Management

Token/session responsibility is separated from the login request.

`LoginBloc` only handles the login request lifecycle.

`AuthSessionBloc` manages the global app session.

### Secure Storage

The authenticated token is stored securely using `flutter_secure_storage`.

Storage key:

```text
StorageKeys.authToken
```

This is used so the app can restore the session after restart.

### Memory Storage

The access token is also kept in memory through `MemoryStorage`.

This gives the network layer fast access to the current token without reading secure storage before every API request.

Current behavior:

```text
login success
  -> AuthSessionBloc receives token
  -> token saved to secure storage
  -> token saved to MemoryStorage
  -> app state becomes authenticated
```

On app start:

```text
AuthSessionStarted
  -> read token from secure storage
  -> if token exists, restore it into MemoryStorage
  -> emit authenticated
  -> otherwise emit unauthenticated
```

On logout:

```text
AuthSessionLogoutRequested
  -> clear MemoryStorage
  -> delete secure auth token
  -> emit unauthenticated
```

## Authorization Header

`ApiInterceptor` attaches the token to authenticated requests:

```http
Authorization: Bearer <token>
```

Login requests are marked with:

```dart
Options(headers: {'No-Authentication': 'true'})
```

The interceptor removes this marker and skips attaching the bearer token for that request.

## Route Guard

Routing is managed with `go_router`.

`AuthSessionBloc` controls access to protected routes.

```text
unauthenticated user -> /login
authenticated user on /login -> /coaching
```

`GoRouterRefreshStream` converts the `AuthSessionBloc` stream into a listenable object for GoRouter. This makes redirects re-run whenever the session state changes.

Example flow:

```text
login succeeds
  -> AuthSessionBloc emits authenticated
  -> GoRouterRefreshStream notifies GoRouter
  -> redirect runs
  -> user moves to /coaching
```

## Dependency Injection

The app uses `get_it`.

Core dependencies are registered in:

```text
lib/core/di/core_di.dart
```

Core DI includes:

- local storage
- memory storage
- Dio
- DioClient
- API interceptor
- network info
- global blocs such as `AuthSessionBloc` and `ThemeBloc`

Auth feature dependencies are registered in:

```text
lib/features/auth/di/auth_di.dart
```

Auth DI includes:

- `AuthRemoteDataSource`
- `AuthRepository`
- `LoginUseCase`
- `LoginBloc`

App-level DI orchestration happens in:

```text
lib/app/app_di/app_di.dart
```

Initialization order:

```text
core_di.initDependencies()
auth_di.initAuthDependencies()
```

## Error Handling

Network errors are parsed in `DioClient`.

Server error messages support both:

```json
{ "message": "Error message" }
```

and:

```json
{ "msg": "Invalid credentials" }
```

Errors are converted into app-level exceptions, then mapped into domain failures in repository implementations.

Common failures:

- `ServerFailure`
- `NetworkFailure`
- `UnauthorizedFailure`
- `ValidationFailure`
- `CacheFailure`
- `UnknownFailure`

## Flavor-Based Network Logging

The app uses flavor configuration.

Development flavor:

```text
enableLogging = true
```

Production flavor:

```text
enableLogging = false
```

`PrettyDioLogger` is added only when the active flavor allows logging.

## Current Auth-Related Routes

```text
/login
/coaching
```

`/coaching` is currently a placeholder protected page. It includes a logout action to test session clearing and redirect behavior.

## Future Feature Guideline

When adding a new feature, follow this order:

```text
1. domain/entities
2. domain/repositories
3. domain/usecases
4. data/models
5. data/datasources
6. data/repositories
7. presentation/bloc
8. presentation/page
9. presentation/widget
10. feature/di
11. app/routes
12. tests
```

Keep page-specific state in page/feature blocs. Keep app-wide state, such as authentication session, theme, or language, in global core blocs.
