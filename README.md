# CampusBuddy-1

**Connect. Discover. Thrive.**

CampusBuddy-1 is your all-in-one companion for navigating campus life. Never miss an important event again with our sleek, intuitive platform that puts the entire campus experience at your fingertips.

## Features

🎓 **Discover events** that match your interests and academic journey  
📆 **Track your schedule** with our seamless calendar integration  
🔔 **Get notified** about upcoming events and registration deadlines  
👥 **Connect with peers** attending the same events  
📱 **Access everything** from anywhere - mobile-first design for students on the go

## Screenshots

[Screenshots coming soon]

## Getting Started

### Prerequisites
- Flutter SDK (version 3.0.0 or later)
- Dart SDK (version 2.17.0 or later)
- Android Studio / VS Code
- Git

### Installation

1. Clone the repository
```bash
git clone https://github.com/Jonathan-321/CampusBuddy-1.git
```

2. Navigate to the project directory
```bash
cd CampusBuddy-1
```

3. Get dependencies
```bash
flutter pub get
```

4. Run the app
```bash
flutter run
```

## Project Structure

The application follows a clean architecture approach with a focus on separation of concerns:

```
lib/
├── config/                  # Configuration files
│   ├── router/              # Routing configuration
│   └── theme/               # Theme configuration
├── data/                    # Data layer
│   ├── models/              # Data models
│   ├── repositories/        # Repository implementations
│   └── services/            # External services
├── domain/                  # Domain layer
│   ├── entities/            # Business entities
│   ├── repositories/        # Repository interfaces
│   └── usecases/            # Business logic use cases
├── logic/                   # Logic layer (contains legacy code)
│   └── blocs/               # BLoC implementations
├── presentation/            # Presentation layer
│   ├── blocs/               # BLoC state management
│   ├── screens/             # UI screens
│   │   ├── auth/            # Authentication screens
│   │   ├── courses/         # Course-related screens
│   │   ├── events/          # Event-related screens
│   │   ├── home/            # Home screen
│   │   ├── map/             # Campus map screens
│   │   ├── profile/         # User profile screens
│   │   └── schedule/        # Schedule screens
│   └── widgets/             # Reusable UI components
└── services/                # Core services (notifications, etc.)
```

### Key Files

- `main.dart`: Application entry point and dependency injection
- `config/router/app_router.dart`: Route definitions using GoRouter
- `presentation/blocs/events/events_bloc.dart`: State management for events
- `domain/entities/event.dart`: Core event entity model

## Architecture

CampusBuddy-1 follows a clean architecture approach with BLoC pattern for state management:

- **Presentation Layer**: UI components and BLoC implementations
- **Domain Layer**: Entities and use cases that define the core business logic
- **Data Layer**: Repositories and data sources

### State Management

The application uses the BLoC (Business Logic Component) pattern to manage state:

- **Events**: Represent user actions or system events
- **States**: Represent the current state of the application
- **BLoCs**: Process events and emit new states

## Git Workflow

We follow a feature branch workflow:

1. **Main Branch**: The `main` branch contains production-ready code
2. **Feature Branches**: Create a new branch for each feature or bugfix
3. **Pull Requests**: Open a PR for review before merging into main

### Branch Naming Convention

Use the following format for branch names:
- `feature/short-description` - For new features
- `bugfix/short-description` - For bug fixes
- `hotfix/short-description` - For urgent fixes
- `refactor/short-description` - For code refactoring

### Commit Message Guidelines

Write clear, concise commit messages:
- Use the present tense ("Add feature" not "Added feature")
- First line should be 50 characters or less
- Reference issues when appropriate ("Fix #123: Add event filtering")

## Contributing

We welcome contributions to CampusBuddy-1! Here's how to contribute:

1. **Fork the Repository**: Create your own fork of the project
2. **Create a Branch**: Create a new branch with a descriptive name
3. **Make Changes**: Implement your feature or bugfix
4. **Follow Code Style**: Ensure your code follows our style guidelines
5. **Write Tests**: Add tests for your changes when applicable
6. **Submit a PR**: Open a pull request with a clear description

### Code Style Guidelines

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format` to format your code
- Run `flutter analyze` to check for linting issues

## Known Issues

- Event registration currently uses mock data
- Profile photo upload not yet implemented
- Push notifications are placeholders

## Roadmap

- [ ] User authentication with Firebase
- [ ] Real-time event updates
- [ ] Personalized event recommendations
- [ ] Social sharing features
- [ ] Dark mode support

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

Jonathan - [GitHub](https://github.com/Jonathan-321)

*Your campus journey starts here.*
