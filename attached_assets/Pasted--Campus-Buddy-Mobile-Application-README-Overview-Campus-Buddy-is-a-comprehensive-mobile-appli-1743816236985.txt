# Campus Buddy Mobile Application - README

## Overview
Campus Buddy is a comprehensive mobile application designed to help students navigate campus life. It provides essential information and services including emergency contacts, campus directory, dining information, orientation resources, campus events, and an interactive map.

## Project Structure
The application follows a clean architecture pattern with the following structure:

```
lib/
  ├── config/           # Configuration files (routes, theme)
  ├── data/             # Data layer (models, repositories, services)
  │   ├── models/       # Data models
  │   ├── repositories/ # Repository implementations
  │   └── services/     # API services and data sources
  ├── domain/           # Domain layer (entities, use cases)
  │   ├── entities/     # Business objects
  │   └── usecases/     # Business logic
  └── presentation/     # Presentation layer (UI components)
      ├── blocs/        # BLoC state management
      ├── screens/      # Screen widgets
      └── widgets/      # Reusable UI components

assets/
  ├── images/          # Image assets
  └── icons/           # Icon assets

test/                  # Test files
```

## Features

1. **Authentication**
   - Login with email/password
   - Google Sign-In
   - Apple Sign-In (iOS only)

2. **Emergency Contacts**
   - List of campus emergency numbers
   - One-tap calling
   - Emergency procedures

3. **Campus Directory**
   - Search for faculty and staff
   - Department listings
   - Contact information

4. **Dining Information**
   - Dining hall hours and menus
   - Nutritional information
   - Special dietary options

5. **Campus Map**
   - Interactive map with search
   - Building information
   - Navigation between locations
   - Points of interest

6. **Events Calendar**
   - Upcoming campus events
   - Filter by category
   - Add to personal calendar
   - Event reminders

## Implementation Plan

### Phase 1: Setup and Core Structure
- [x] Initialize Flutter project
- [x] Set up project structure (clean architecture)
- [x] Configure dependencies in pubspec.yaml
- [ ] Implement theme configuration
- [ ] Set up routing

### Phase 2: Authentication
- [ ] Implement authentication UI
- [ ] Set up Firebase Authentication
- [ ] Implement Google Sign-In
- [ ] Implement Apple Sign-In
- [ ] Create user profile storage

### Phase 3: Core Features
- [ ] Implement Emergency Contacts module
- [ ] Implement Campus Directory module
- [ ] Implement Dining Information module

### Phase 4: Map and Events
- [ ] Implement Campus Map with Google Maps integration
- [ ] Add building data and search functionality
- [ ] Implement Events Calendar
- [ ] Add notification system for events

### Phase 5: Testing and Refinement
- [ ] Write unit tests for business logic
- [ ] Write widget tests for UI components
- [ ] Perform integration testing
- [ ] UI/UX refinements

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio or VS Code with Flutter extensions
- Firebase project (for authentication and data storage)
- Google Maps API key (for map functionality)

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Configure Firebase (follow instructions in `firebase_setup.md`)
4. Add your Google Maps API key in `android/app/src/main/AndroidManifest.xml` and `ios/Runner/AppDelegate.swift`
5. Run the app with `flutter run`

## Development Notes

### Current Status
The project structure has been set up according to clean architecture principles, and dependencies have been configured in the pubspec.yaml file. The next steps involve implementing the core functionality and UI components.

### Known Issues
- Disk space constraints may affect build performance
- Firebase configuration needs to be completed

### Future Enhancements
- Offline mode for accessing essential information without internet
- Push notifications for campus alerts
- Integration with university LMS (Learning Management System)
- Personalized schedule based on enrolled courses

## Features
- **Emergency Contacts**: Quick access to campus police and residence assistant numbers
- **Campus Directory**: Searchable directory of faculty, staff, and departments
- **Dining & Orientation**: Information about dining locations, meal plans, and orientation events
- **Events System**: Calendar of campus events with push notifications
- **Federated Authentication**: Sign in with Google or Apple accounts
- **Campus Map**: GPS-enabled interactive map for campus navigation

## Technology Stack
- **Frontend**: Flutter framework
- **State Management**: BLoC pattern
- **Authentication**: Firebase Authentication
- **Maps**: Google Maps API
- **Notifications**: Flutter Local Notifications

## Project Structure
The application follows a clean architecture pattern with separation of concerns:
- **Presentation Layer**: UI components, screens, and BLoC state management
- **Domain Layer**: Business logic and use cases
- **Data Layer**: Data models, repositories, and external services

## Getting Started
Please refer to the `implementation_guide.md` file for detailed instructions on setting up and implementing the application.

## Screenshots
(Screenshots would be included here in a real implementation)

## Requirements
- Flutter SDK (latest stable version)
- Android Studio or VS Code with Flutter extensions
- Firebase account
- Google Maps API key

## Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Configure Firebase and Google Maps API keys
4. Run `flutter run` to start the application

## Customization
The application is designed to be easily customizable for different campuses:
- Update the data files with your campus-specific information
- Modify the theme colors to match your institution's branding
- Add or remove features based on your specific needs

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements
- Flutter team for the amazing framework
- Firebase for authentication services
- Google Maps for mapping services
