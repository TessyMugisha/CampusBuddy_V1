import 'package:equatable/equatable.dart';

/// Base class for all failures in the domain layer
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Server failure when interacting with remote API
class ServerFailure extends Failure {
  const ServerFailure([String message = 'A server error occurred'])
      : super(message);
}

/// Cache failure when reading/writing local data
class CacheFailure extends Failure {
  const CacheFailure([String message = 'A cache error occurred'])
      : super(message);
}

/// Network failure when no internet connection
class NetworkFailure extends Failure {
  const NetworkFailure(
      [String message =
          'A network error occurred. Please check your connection.'])
      : super(message);
}

/// AI service specific failure for the Campus Oracle feature
class AIServiceFailure extends Failure {
  const AIServiceFailure(
      [String message = 'Could not connect to Campus Oracle'])
      : super(message);
}
