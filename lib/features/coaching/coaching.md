# Coaching Feature

This folder contains the coaching module for the app. It is built with clean architecture and uses BLoC for presentation state.

## Folder Structure

```text
coaching/
├── data/
│   ├── datasources/
│   │   └── coaching_remote_data_source.dart
│   ├── models/
│   │   ├── coaching_program_list_model.dart
│   │   ├── coaching_details_model.dart
│   │   ├── coaching_details_with_sessions_model.dart
│   │   ├── coaching_session_model.dart
│   │   ├── current_coaching_session_model.dart
│   │   ├── coaching_feed_page_model.dart
│   │   ├── coaching_feed_model.dart
│   │   ├── coaching_lesson_model.dart
│   │   ├── coaching_task_exercise_model.dart
│   │   ├── coaching_journal_model.dart
│   │   ├── coaching_tracker_model.dart
│   │   ├── coaching_program_submission_model.dart
│   │   ├── coaching_feed_reaction_model.dart
│   │   └── coaching_upload_file_model.dart
│   └── repositories/
│       └── coaching_repository_impl.dart
├── domain/
│   ├── entities/
│   ├── repositories/
│   │   └── coaching_repository.dart
│   └── usecases/
│       ├── get_enrolled_coaching_programs_usecase.dart
│       ├── get_coaching_details_with_sessions_usecase.dart
│       └── get_coaching_feeds_usecase.dart
├── presentation/
│   ├── bloc/
│   │   ├── coaching_program_list_bloc.dart
│   │   ├── coaching_details_bloc.dart
│   │   └── coaching_feed_bloc.dart
│   ├── pages/
│   │   ├── coaching_list_page.dart
│   │   └── coaching_details_page.dart
│   └── widgets/
│       ├── coaching_program_card.dart
│       ├── session_selector_drawer.dart
│       ├── coaching_feed_card.dart
│       ├── lesson_feed_card.dart
│       ├── task_exercise_feed_card.dart
│       ├── journal_feed_card.dart
│       └── coaching_notes_bottom_sheet.dart
└── di/
    └── coaching_di.dart
```

## What This Feature Does

The coaching feature currently handles:

- enrolled coaching program list
- search with 800ms debounce
- pull-to-refresh
- pagination/load more
- coaching details with sessions
- session drawer with parent/child session hierarchy
- selected/current session state
- feed list per selected session
- feed pagination
- lesson/task/journal feed cards
- tracker input form UI
- journal draft UI
- notes bottom sheet UI shell
- theme toggle from the coaching list app bar

## APIs Used

### Enrolled Coaching Program List

```http
GET {{BASE_URL}}/student/coaching-programs/getEnrolledCoachingProgramList
```

Query params:

```text
page
limit
search optional
```

This API powers `CoachingListPage`.

### Coaching Details + Sessions

```http
GET {{BASE_URL}}/coach/feeds/content/{programId}
```

Query params:

```text
program_id
user_zone
```

This API returns:

- coaching details
- parent sessions
- child sessions
- current session info

### Coaching Feed List

```http
GET {{BASE_URL}}/coach/feeds/get-all/{programId}/session/{sessionId}
```

Query params:

```text
program_id
session_id
page
limit
```

This API returns paginated feed items for the selected session.

## Clean Architecture Flow

### Coaching List

```text
CoachingListPage
  -> CoachingProgramListBloc
  -> GetEnrolledCoachingProgramsUseCase
  -> CoachingRepository
  -> CoachingRepositoryImpl
  -> CoachingRemoteDataSource
  -> DioClient
  -> CoachingProgramListModel
  -> CoachingProgramListBloc emits list state
```

### Coaching Details

```text
CoachingDetailsPage
  -> CoachingDetailsBloc
  -> GetCoachingDetailsWithSessionsUseCase
  -> CoachingRepository
  -> CoachingRepositoryImpl
  -> CoachingRemoteDataSource
  -> DioClient
  -> CoachingDetailsWithSessionsModel
  -> CoachingDetailsBloc emits details/session state
```

### Feed List

```text
Selected session
  -> CoachingFeedBloc
  -> GetCoachingFeedsUseCase
  -> CoachingRepository
  -> CoachingRepositoryImpl
  -> CoachingRemoteDataSource
  -> DioClient
  -> CoachingFeedPageModel
  -> CoachingFeedBloc emits feed state
```

## Layer Responsibilities

### Domain Layer

The domain layer contains pure app concepts and business rules. It does not know about Dio, JSON, Flutter widgets, or storage.

Important entities:

```text
CoachingProgram
CoachingProgramPage
CoachingDetails
CoachingSession
CurrentCoachingSession
CoachingDetailsWithSessions
CoachingFeed
CoachingFeedPage
CoachingLesson
CoachingTaskExercise
CoachingJournal
CoachingTracker
CoachingProgramSubmission
CoachingNote
```

`CoachingDetailsWithSessions` also owns selected session logic:

- session-based coaching: select the session where `isCurrent == true`
- week-based coaching: match `sessionDate` with today's date
- fallback: use `current_session.current_session_id`

This keeps the UI simple. The page asks the entity for `selectedSession` instead of manually deciding.

### Repository Contract

`domain/repositories/coaching_repository.dart`

Defines what the coaching feature can do:

```text
getEnrolledCoachingPrograms(page, perPage, search)
getCoachingDetailsWithSessions(programId, userZone)
getCoachingFeeds(programId, sessionId, page, limit)
```

### Use Cases

Use cases keep presentation code away from repository details:

```text
GetEnrolledCoachingProgramsUseCase
GetCoachingDetailsWithSessionsUseCase
GetCoachingFeedsUseCase
```

## Data Layer

The data layer handles API calls, JSON parsing, and exception-to-failure mapping.

### Remote Data Source

`data/datasources/coaching_remote_data_source.dart`

Calls:

- program list API
- details + sessions API
- feed list API

It throws `ServerException` if an expected response body is empty.

### Models

Models extend domain entities and parse API JSON.

Important parsing details:

- program list response uses `meta` and `data`
- details response has `coaching_details`, `sessions`, and `current_session`
- feed list response has `meta`, `data`, `coaching_type`, and `student_enrollment_id`
- `feedData` is a JSON string and must be decoded before reading lesson/task/journal data
- `task_exercise` feed type maps to the task card
- tracker input definitions come from the sibling `tracker` key
- previous submission data comes from `coachingProgramSubmission`

### Repository Implementation

`data/repositories/coaching_repository_impl.dart`

Calls the remote data source and maps errors into failures:

- `ValidationFailure`
- `UnauthorizedFailure`
- `NetworkFailure`
- `ServerFailure`
- `CacheFailure`
- `UnknownFailure`

## Presentation Layer

### Coaching Program List

`presentation/pages/coaching_list_page.dart`

Responsibilities:

- provides `CoachingProgramListBloc`
- shows `SliverAppBar`
- theme toggle on the left
- logout button on the right
- centered title
- search bar
- shimmer loading grid
- empty/error states
- program grid
- pull-to-refresh
- scroll-to-bottom pagination
- card tap navigation to details

Related widgets:

```text
coaching_search_bar.dart
coaching_program_grid.dart
coaching_program_card.dart
coaching_program_skeleton_card.dart
coaching_empty_view.dart
coaching_error_view.dart
```

### Coaching Details

`presentation/pages/coaching_details_page.dart`

Responsibilities:

- provides `CoachingDetailsBloc`
- provides `CoachingFeedBloc`
- displays program banner/info
- displays program description as HTML
- opens session drawer
- opens notes bottom sheet
- loads feed for selected session
- reloads feed on session change
- pull-to-refresh
- feed pagination
- home floating action button

No session UI state is kept with `setState`. Session selection and expansion are owned by `CoachingDetailsBloc`.

### Session Drawer

`presentation/widgets/session_selector_drawer.dart`

Responsibilities:

- shows parent sessions
- shows child sessions
- expands/collapses parent sessions
- highlights selected session
- shows current tag
- shows completion percentage
- closes drawer after selecting a session

### Feed List

`presentation/widgets/coaching_feed_list.dart`

Responsibilities:

- listens to `CoachingFeedBloc`
- shows loading/error/empty states
- renders `SliverList.separated`
- shows bottom loader during pagination
- renders `CoachingFeedCard`

### Feed Cards

`coaching_feed_card.dart` is only a wrapper. It switches by feed type:

```text
lesson -> LessonFeedCard
task -> TaskExerciseFeedCard
journal -> JournalFeedCard
unknown -> UnknownFeedCard
```

This was split because the original feed card file became too large.

### Lesson Feed

`lesson_feed_card.dart`

Supports:

- text lesson: HTML description
- video lesson: thumbnail/placeholder + play button
- audio lesson: audio-style row + open link
- PDF/PPT/download lesson: open/download link with `url_launcher`
- comment button

### Task/Exercise Feed

`task_exercise_feed_card.dart`

Supports:

- title
- HTML description
- tracker form when tracker data exists
- duration input with start/end time picker
- number input with unit and goal
- question text input
- select one dropdown
- previous submitted values where available
- submit/update button shell

Time picker state is managed by `CoachingFeedBloc` through:

```text
CoachingTrackerTimeChanged
trackerTimeValues
```

### Journal Feed

`journal_feed_card.dart`

Supports:

- title
- HTML description
- journal text input
- character limit counter from `char_limit`
- previous answer prefill
- submit/update button shell

Journal draft/counter state is managed by `CoachingFeedBloc` through:

```text
CoachingJournalDraftChanged
journalDrafts
```

### Notes Bottom Sheet

`coaching_notes_bottom_sheet.dart`

Current status: UI shell is implemented, API integration is not done yet.

It supports:

- 80% screen height
- title `Coach Notes`
- close icon
- scrollable notes list
- item border using outline color at 20% opacity
- title bar with `primaryContainer`
- HTML content
- timestamp footer
- only displays notes where `isViewAllowed == true`

The current page passes an empty notes list until the notes API is connected.

## BLoCs

### CoachingProgramListBloc

Events:

```text
LoadCoachingPrograms
LoadMoreCoachingPrograms
```

State tracks:

```text
status
programs
currentPage
limit
hasNextPage
search
errorMessage
```

### CoachingDetailsBloc

Events:

```text
LoadCoachingDetails
CoachingSessionSelected
CoachingParentSessionToggled
```

State tracks:

```text
status
detailsWithSessions
selectedSession
expandedParentIds
errorMessage
```

This Bloc owns session selection and expansion state.

### CoachingFeedBloc

Events:

```text
LoadCoachingFeeds
LoadMoreCoachingFeeds
CoachingTrackerTimeChanged
CoachingJournalDraftChanged
```

State tracks:

```text
status
feeds
programId
sessionId
currentPage
limit
hasNextPage
trackerTimeValues
journalDrafts
errorMessage
```

This Bloc owns feed loading, feed pagination, tracker time values, and journal draft values.

## Dependency Injection

Coaching dependencies are registered in:

```text
di/coaching_di.dart
```

Registration order:

```text
CoachingRemoteDataSource
CoachingRepository
GetEnrolledCoachingProgramsUseCase
GetCoachingDetailsWithSessionsUseCase
GetCoachingFeedsUseCase
CoachingProgramListBloc
CoachingDetailsBloc
CoachingFeedBloc
```

BLoCs are registered as factories because they are page-specific and should follow page lifecycle.

## Routing

Routes are defined in:

```text
lib/app/routes/app_routes.dart
lib/app/routes/app_router.dart
```

Current coaching routes:

```text
/coaching
/coaching/:programId
```

Program cards navigate to:

```dart
AppRoutes.coachingDetailsPath(program.id)
```

## Packages Used By This Feature

```text
flutter_bloc
equatable
dartz
dio
cached_network_image
flutter_html
url_launcher
shimmer
go_router
intl
```

