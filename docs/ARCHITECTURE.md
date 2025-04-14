# Campus Buddy Architecture Documentation

## Overview
Campus Buddy is a Flutter application built using Clean Architecture principles. The application is designed to help students manage their campus life by providing features like event management, course tracking, campus navigation, and more.

## Architecture Layers

### 1. Presentation Layer (`lib/presentation/`)
- **Screens**: UI components that represent different pages of the application
- **Blocs**: State management using BLoC pattern
- **Widgets**: Reusable UI components
- **Navigation**: Handled by GoRouter

### 2. Domain Layer (`lib/domain/`)
- **Entities**: Core business objects
- **Use Cases**: Business logic operations
- **Repositories**: Abstract interfaces for data operations

### 3. Data Layer (`lib/data/`)
- **Repositories**: Implementation of domain repository interfaces
- **Data Sources**: Local and remote data sources
- **Models**: Data transfer objects (DTOs)

### 4. Services Layer (`lib/services/`)
- **External Services**: Integration with third-party services
- **Utilities**: Helper functions and common services

### 5. Logic Layer (`lib/logic/`)
- **Business Logic**: Implementation of complex business rules
- **State Management**: Additional state management components

## Key Components and Their Relationships

### Authentication Flow
1. User enters credentials in `LoginScreen` or `SignupScreen`
2. `AuthBloc` handles authentication state
3. On successful auth, user is redirected to `HomeScreen`

### Event Management Flow
1. `EventsScreen` displays events list
2. `EventsBloc` manages event state and operations
3. `EventsUseCase` handles business logic
4. Data is fetched through repository implementations

### Course Management Flow
1. `CoursesScreen` displays course list
2. `CoursesBloc` manages course state
3. Course details are shown in `CourseDetailScreen`

### Navigation Structure
- Root navigation handled by `AppRouter`
- Bottom navigation for main app sections
- Nested navigation for feature-specific screens

## State Management
The application uses BLoC pattern for state management:
- Each feature has its own BLoC
- Events trigger state changes
- UI components react to state changes

## Data Flow
1. UI triggers an event
2. BLoC processes the event
3. Use Case executes business logic
4. Repository fetches data
5. Data is transformed and returned to UI

## Dependencies
- `flutter_bloc`: State management
- `go_router`: Navigation
- `flutter_local_notifications`: Notifications
- Other dependencies listed in `pubspec.yaml`

## Best Practices
1. Follow Clean Architecture principles
2. Use dependency injection
3. Implement proper error handling
4. Follow Flutter best practices for UI
5. Maintain separation of concerns

## Making Changes
When making changes to the codebase:
1. Identify the appropriate layer for your change
2. Follow the existing patterns in that layer
3. Update relevant documentation
4. Test thoroughly
5. Consider backward compatibility

## Common Pitfalls to Avoid
1. Mixing business logic with UI
2. Direct data access from UI layer
3. Duplicating code across layers
4. Ignoring error handling
5. Breaking existing patterns 