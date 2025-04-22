class User {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final bool isEmailVerified;

  User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.isEmailVerified = false,
  });

  // Factory constructor for creating an empty user
  factory User.empty() {
    return User(
      id: '',
      email: '',
      displayName: null,
      photoUrl: null,
      isEmailVerified: false,
    );
  }

  bool get isAuthenticated => id.isNotEmpty;
}
