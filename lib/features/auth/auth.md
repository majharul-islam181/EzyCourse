# Auth Feature

This folder contains the authentication feature for the app. It is built with clean architecture and uses BLoC for presentation state.

## Folder Structure

```text
auth/
├── data/
│   ├── datasources/
│   │   └── auth_remote_data_source.dart
│   ├── models/
│   │   └── auth_session_model.dart
│   └── repositories/
│       └── auth_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── auth_session.dart
│   ├── repositories/
│   │   └── auth_repository.dart
│   └── usecases/
│       └── login_usecase.dart
├── presentation/
│   ├── bloc/
│   │   ├── login_bloc.dart
│   │   ├── login_event.dart
│   │   └── login_state.dart
│   ├── page/
│   │   └── login_page.dart
│   └── widget/
│       └── login_form.dart
└── di/
    └── auth_di.dart
```

## What This Feature Does

The auth feature currently handles:

- email/password login
- login loading state
- login error state
- login success state
- parsing login token response
- passing successful session token to the global `AuthSessionBloc`

It does not directly own long-term session state. Global session management is handled in:

```text
lib/core/blocs/auth_session/
```

## Login API

Endpoint:

```http
POST {{BASE_URL}}/student/auth/login
```

Request:

```json
{
  "email": "user@example.com",
  "password": "password123",
  "app_fcm_token": "optional_fcm_token"
}
```

Success response:

```json
{
  "type": "bearer",
  "token": "token_value"
}
```

## Clean Architecture Flow

```text
LoginPage
  -> LoginBloc
  -> LoginUseCase
  -> AuthRepository
  -> AuthRepositoryImpl
  -> AuthRemoteDataSource
  -> DioClient
  -> AuthSessionModel
  -> LoginBloc emits success
  -> LoginPage sends token to AuthSessionBloc
```

## Layer Responsibilities

### Domain Layer

The domain layer contains pure business rules. It does not know about Dio, JSON, Flutter widgets, or storage.

`domain/entities/auth_session.dart`

Defines the auth session entity:

```text
type
token
```

`domain/repositories/auth_repository.dart`

Defines what auth can do:

```text
login(email, password, appFcmToken)
```

`domain/usecases/login_usecase.dart`

Runs the login business action by calling the repository contract.

### Data Layer

The data layer handles API calls, response parsing, and error mapping.

`data/models/auth_session_model.dart`

Parses the server response:

```json
{
  "type": "bearer",
  "token": "token_value"
}
```

`data/datasources/auth_remote_data_source.dart`

Calls the login API through `DioClient`.

The login request sends this header:

```dart
Options(headers: {'No-Authentication': 'true'})
```

That tells the API interceptor not to attach an old bearer token to the login request.

`data/repositories/auth_repository_impl.dart`

Calls the remote data source and converts exceptions into domain failures:

- `ValidationFailure`
- `UnauthorizedFailure`
- `NetworkFailure`
- `ServerFailure`
- `CacheFailure`
- `UnknownFailure`

### Presentation Layer

The presentation layer handles UI and UI state.

`presentation/bloc/login_event.dart`

Current event:

```text
LoginSubmitted
```

`presentation/bloc/login_state.dart`

Current states:

```text
initial
loading
success
failure
```

`presentation/bloc/login_bloc.dart`

Handles the login form workflow:

```text
LoginSubmitted
  -> emit loading
  -> call LoginUseCase
  -> emit success with AuthSession
  -> or emit failure with error message
```

`presentation/page/login_page.dart`

Owns page-level behavior:

- provides `LoginBloc`
- provides `PasswordVisibilityCubit`
- listens to login success/failure
- shows snackbar feedback
- sends token to `AuthSessionBloc` after login success

`presentation/widget/login_form.dart`

Owns the login form UI:

- email field
- password field
- password visibility toggle
- login button
- loading indicator
- inline error message

## Session Handoff

Auth feature does not permanently store the token directly.

After login succeeds:

```text
LoginBloc emits success with AuthSession
LoginPage reads session.token
LoginPage dispatches AuthSessionAuthenticated(token)
AuthSessionBloc stores token securely and in memory
```

Global session storage happens in:

```text
lib/core/blocs/auth_session/auth_session_bloc.dart
```

That Bloc:

- saves token to secure storage
- stores token in `MemoryStorage`
- restores token on app start
- clears token on logout
- controls authenticated/unauthenticated app state

## Dependency Injection

Auth dependencies are registered in:

```text
di/auth_di.dart
```

Registration order:

```text
AuthRemoteDataSource
AuthRepository
LoginUseCase
LoginBloc
```

`LoginBloc` is registered as a factory because it is page-specific and should be recreated for the login page lifecycle.

## Routing

The login route is defined in:

```text
lib/app/routes/app_router.dart
```

Route:

```text
/login
```

After successful login, this feature does not directly navigate. Instead, it updates `AuthSessionBloc`. GoRouter listens to session state and redirects authenticated users to:

```text
/coaching
```

Strict rules:

```text
LoginBloc = login screen workflow
AuthSessionBloc = global app session
```

@majharul-islam181

