# Domain Layer and Repositories Documentation

## Overview
This document explains the relationships between the domain layer, repositories, and use cases in the Campus Buddy application.

## Architecture Flow

```
UI Layer (Screens) 
    ↓
Presentation Layer (BLoCs)
    ↓
Domain Layer (Use Cases)
    ↓
Repository Layer (Implementations)
    ↓
Data Sources (Local/Remote)
```

## Domain Layer Structure

### Use Cases
Each use case represents a specific business operation:

1. **AuthUseCase**
   - Handles authentication operations
   - Dependencies: AuthRepository
   - Used by: AuthBloc

2. **EventsUseCase**
   - Manages event-related operations
   - Dependencies: EventsRepository
   - Used by: EventsBloc

3. **MapUseCase**
   - Handles campus navigation
   - Dependencies: MapRepository
   - Used by: MapBloc

4. **DiningUseCase**
   - Manages dining locations and menus
   - Dependencies: DiningRepository
   - Used by: DiningBloc

5. **DirectoryUseCase**
   - Handles campus directory operations
   - Dependencies: DirectoryRepository
   - Used by: DirectoryBloc

6. **EmergencyUseCase**
   - Manages emergency contacts and procedures
   - Dependencies: EmergencyRepository
   - Used by: EmergencyBloc

## Repository Layer Structure

### Repository Implementations

1. **AuthRepository**
   - Implements authentication operations
   - Handles user login, registration, and session management
   - Connects to authentication services

2. **EventsRepository**
   - Implements event-related operations
   - Manages event data storage and retrieval
   - Handles event filtering and categorization

3. **MapRepository**
   - Implements campus navigation features
   - Manages location data and routing
   - Handles map-related services

4. **DiningRepository**
   - Implements dining-related operations
   - Manages dining locations and menu data
   - Handles dining service integrations

5. **DirectoryRepository**
   - Implements directory operations
   - Manages contact and department information
   - Handles directory service integrations

6. **EmergencyRepository**
   - Implements emergency-related operations
   - Manages emergency contacts and procedures
   - Handles emergency service integrations

## Navigation System

### Navigation Structure
The application uses two navigation systems:

1. **GoRouter (Primary Navigation)**
   - Located in: `lib/config/router/app_router.dart`
   - Handles all modern navigation
   - Supports nested navigation
   - Manages bottom navigation

2. **Legacy Router (Backup)**
   - Located in: `lib/config/routes.dart`
   - Maintained for backward compatibility
   - Uses traditional MaterialPageRoute

### Navigation Flow

```
Root Navigation
├── Splash Screen (/)
├── Auth Routes
│   ├── Login (/login)
│   └── Signup (/signup)
└── Main App Shell
    ├── Home (/home)
    ├── Events (/events)
    │   └── Event Details (/events/:id)
    ├── Courses (/courses)
    │   └── Course Details (/courses/:id)
    ├── Map (/map)
    ├── Schedule (/schedule)
    ├── Assignments (/assignments)
    ├── Dining (/dining)
    ├── Transit (/transit)
    └── Profile (/profile)
```

### Adding New Features

1. **Domain Layer**
   - Create new entity in `domain/entities/`
   - Create new use case in `domain/usecases/`
   - Define repository interface

2. **Repository Layer**
   - Implement repository interface
   - Add data source connections
   - Implement CRUD operations

3. **Navigation**
   - Add new route in `app_router.dart`
   - Update bottom navigation if needed
   - Add screen imports

## Best Practices

1. **Domain Layer**
   - Keep business logic in use cases
   - Define clear interfaces
   - Maintain single responsibility

2. **Repository Layer**
   - Implement proper error handling
   - Use appropriate data sources
   - Cache data when necessary

3. **Navigation**
   - Use named routes
   - Handle deep linking
   - Maintain consistent navigation patterns

## Common Patterns

1. **Feature Implementation**
   ```
   UI Screen → BLoC → Use Case → Repository → Data Source
   ```

2. **Data Flow**
   ```
   Data Source → Repository → Use Case → BLoC → UI
   ```

3. **Error Handling**
   ```
   Repository → Use Case → BLoC → UI (Error State)
   ```

## Making Changes

When adding new features:

1. Start with domain layer
   - Define entities
   - Create use case
   - Define repository interface

2. Implement repository
   - Add data sources
   - Implement operations
   - Add error handling

3. Update navigation
   - Add new routes
   - Update navigation structure
   - Handle deep linking

4. Update UI
   - Create screens
   - Implement BLoC
   - Connect to use case 