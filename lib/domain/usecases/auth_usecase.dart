import 'dart:async';
import '../../data/repositories/auth_repository.dart';
import '../entities/user.dart';

class AuthUseCase {
  final AuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  // Factory constructor for creating a mock instance without dependencies
  factory AuthUseCase.mock() {
    return _MockAuthUseCase();
  }

  // Sign in with email and password
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    // Validate inputs
    if (email.isEmpty || password.isEmpty) {
      throw ArgumentError('Email and password cannot be empty');
    }

    if (!_isValidEmail(email)) {
      throw ArgumentError('Invalid email format');
    }

    if (password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }

    try {
      return await _authRepository.signInWithEmailAndPassword(email, password);
    } catch (e) {
      rethrow;
    }
  }

  // Create a new user with email and password
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    // Validate inputs
    if (email.isEmpty || password.isEmpty) {
      throw ArgumentError('Email and password cannot be empty');
    }

    if (!_isValidEmail(email)) {
      throw ArgumentError('Invalid email format');
    }

    if (password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }

    try {
      return await _authRepository.createUserWithEmailAndPassword(
          email, password);
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with Google
  Future<User> signInWithGoogle() async {
    try {
      return await _authRepository.signInWithGoogle();
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Get current user
  Future<User> getCurrentUser() async {
    try {
      return await _authRepository.getCurrentUser();
    } catch (e) {
      rethrow;
    }
  }

  // Get auth state changes stream
  Stream<User> get authStateChanges => _authRepository.authStateChanges;

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    if (email.isEmpty) {
      throw ArgumentError('Email cannot be empty');
    }

    if (!_isValidEmail(email)) {
      throw ArgumentError('Invalid email format');
    }

    try {
      await _authRepository.sendPasswordResetEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  // Helper method to validate email format
  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegExp.hasMatch(email);
  }
}

// Mock implementation for testing purposes
class _MockAuthUseCase implements AuthUseCase {
  @override
  AuthRepository get _authRepository => throw UnimplementedError();

  final StreamController<User> _authStateController =
      StreamController<User>.broadcast();

  // Mock authentication state
  User? _currentUser;

  _MockAuthUseCase() {
    // Initialize with no authenticated user
    _currentUser = null;
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (email.isEmpty || password.isEmpty) {
      throw ArgumentError('Email and password cannot be empty');
    }

    if (!_isValidEmail(email)) {
      throw ArgumentError('Invalid email format');
    }

    if (password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }

    // Create a mock user
    _currentUser = User(
      id: 'mock-user-id',
      email: email,
      displayName: email.split('@')[0],
      photoUrl: 'https://ui-avatars.com/api/?name=${email.split('@')[0]}',
      isEmailVerified: true,
    );

    _authStateController.add(_currentUser!);
    return _currentUser!;
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (email.isEmpty || password.isEmpty) {
      throw ArgumentError('Email and password cannot be empty');
    }

    if (!_isValidEmail(email)) {
      throw ArgumentError('Invalid email format');
    }

    if (password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }

    // Create a mock user
    _currentUser = User(
      id: 'mock-user-id',
      email: email,
      displayName: 'New User',
      photoUrl: null,
      isEmailVerified: false,
    );

    _authStateController.add(_currentUser!);
    return _currentUser!;
  }

  @override
  Future<User> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Create a mock user
    _currentUser = User(
      id: 'mock-google-user-id',
      email: 'google-user@example.com',
      displayName: 'Google User',
      photoUrl: 'https://ui-avatars.com/api/?name=Google+User',
      isEmailVerified: true,
    );

    _authStateController.add(_currentUser!);
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
    _authStateController.add(_currentUser ?? User.empty());
  }

  @override
  Future<User> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentUser ?? User.empty();
  }

  @override
  Stream<User> get authStateChanges => _authStateController.stream;

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (email.isEmpty) {
      throw ArgumentError('Email cannot be empty');
    }

    if (!_isValidEmail(email)) {
      throw ArgumentError('Invalid email format');
    }

    // Simulate success (no action needed in mock)
  }

  @override
  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegExp.hasMatch(email);
  }

  // Clean up resources when done
  void dispose() {
    _authStateController.close();
  }
}
