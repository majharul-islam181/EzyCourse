# EzyCourse

EzyCourse is a Flutter coaching module built with clean architecture, BLoC state management, secure session handling, guarded routing, Material 3 theming, and flavor-based configuration.

The current app includes:

- Email/password authentication
- Secure auth token persistence
- Protected routing with session restore
- Coaching program list with search, pagination, pull-to-refresh, and shimmer loading
- Coaching details with session selector, current-session handling, notes bottom sheet, and paginated feed list
- Feed cards for lessons, task/exercise tracker inputs, journals, and unknown feed types
- Light/dark theme switching
- Development and production flavors
- Production-grade bootstrap with guarded error handling

## Setup Instructions

### Requirements

- Flutter SDK matching the project SDK constraints
- Dart SDK `^3.11.3`
- Android Studio or Xcode for emulator/device builds
- A valid API base URL configured in the project constants/flavor setup

### Install Dependencies

```bash
flutter pub get
```

### Run The App

Development flavor:

```bash
flutter run -t lib/main_development.dart
```

Production flavor:

```bash
flutter run -t lib/main_production.dart --release
```

Default entrypoint:

```bash
flutter run -t lib/main.dart
```

`lib/main.dart` currently delegates to the development entrypoint for local work.

### Useful Checks

```bash
dart format lib test
dart analyze
```

## Architecture Overview

The app follows a feature-first clean architecture style:

```text
presentation -> domain -> data
```

Each feature owns its business flow and is split by layer:

```text
lib/features/<feature>/
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
│   ├── pages/
│   └── widgets/
└── di/
```

Shared app infrastructure lives in `lib/core`:

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

App-level setup lives in `lib/app`:

```text
lib/app/
├── app.dart
├── bootstrap.dart
├── app_di/
└── routes/
```

### State Management

The app uses BLoC/Cubit through `flutter_bloc`.

- Feature state stays inside the feature presentation layer.
- Global state stays in `lib/core/blocs`.
- `AuthSessionBloc` owns logged-in/logged-out app state.
- `ThemeBloc` owns app theme mode.
- Login, coaching list, coaching details, and coaching feed flows use dedicated BLoCs.

### Dependency Injection

The app uses `get_it`.

Initialization starts from:

```text
lib/app/app_di/app_di.dart
```

Feature DI files are registered from there:

```text
core_di -> auth_di -> coaching_di
```

This keeps each feature responsible for its own data source, repository, use case, and BLoC registrations.

### Networking

Networking is handled through Dio.

- `DioClient` centralizes API calls and error parsing.
- `ApiInterceptor` attaches the `Authorization: Bearer <token>` header after login.
- Login requests skip auth headers through a no-auth marker.
- Server messages such as `{ "msg": "Invalid credentials" }` are mapped into user-facing failures.
- Pretty Dio logging is enabled only when the active flavor allows logging.

### Session Management

Authentication is intentionally split into two responsibilities:

- `LoginBloc` handles only the login request lifecycle.
- `AuthSessionBloc` handles global app session state.

After login:

```text
token from API
  -> secure storage
  -> memory storage
  -> authenticated app state
  -> protected route access
```

On app start, the session bloc restores the token from secure storage and loads it into memory storage. On logout, both secure and memory storage are cleared.

### Routing

Routing uses `go_router`.

- Unauthenticated users are redirected to `/login`.
- Authenticated users are redirected away from `/login`.
- `GoRouterRefreshStream` lets GoRouter react to session state changes.

Current main routes:

```text
/login
/coaching
/coaching/:programId
```

### App Bootstrap

App startup is centralized in:

```text
lib/app/bootstrap.dart
```

It wraps startup with:

- `runZonedGuarded`
- `FlutterError.onError`
- `PlatformDispatcher.instance.onError`

This gives the app one place to handle uncaught runtime errors. A production crash reporting tool such as Firebase Crashlytics or Sentry can be connected there later.

## Implemented Features

### Authentication

The auth feature supports:

- Email and password login
- Loading and error UI states
- Secure token storage
- Session restore
- Logout
- Protected navigation

Detailed auth documentation:

```text
lib/features/auth/auth.md
```

### Coaching

The coaching feature supports:

- Enrolled coaching program list
- Search with debounce
- Pagination and pull-to-refresh
- Shimmer loading state
- Coaching details and sessions
- Auto-selected current session
- Parent/child session drawer
- Feed pagination by selected session
- Lesson, task/exercise, journal, and fallback feed cards
- Coach notes bottom sheet

Detailed coaching documentation:

```text
lib/features/coaching/coaching.md
```

## Assumptions And Trade-Offs

- The app currently uses bearer token authentication without refresh token handling because the provided login response only returns `type` and `token`.
- The token is stored in secure storage for persistence and memory storage for fast request access.
- Feed submission buttons and tracker/journal forms are prepared at UI level, but submit/update APIs should be connected when the backend endpoints are available.
- Lesson media types use practical mobile UI placeholders where a full viewer/player is outside the required scope.
- Production crash reporting is not connected yet; the bootstrap file is ready for Crashlytics, Sentry, or another reporter.
- The default `main.dart` entrypoint runs development for easier local testing. Production builds should use `lib/main_production.dart`.
- Feature documentation is stored beside the feature so future changes can be understood without reading the full app.

## Screenshots Or Screen Recording

Add final app screenshots or a screen recording here before submission.

Recommended files:

```text
docs/screenshots/login.png
docs/screenshots/coaching-list.png
docs/screenshots/coaching-details.png
docs/screenshots/session-drawer.png
docs/screenshots/feed-cards.png
docs/recordings/app-demo.mp4
```

Preview table:

| Screen | Preview |
| --- | --- |
| Login | `screenshots/login.png` |
| Coaching List | `screenshots/coaching-list.png` |
| Coaching Details | `screenshots/coaching-details.png` |
| Session Drawer | `screenshots/session-drawer.png` |
| Feed Cards | `screenshots/feed-cards.png` |

