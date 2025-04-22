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
  const ServerFailure([super.message = 'A server error occurred']);
}

/// Cache failure when reading/writing local data
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'A cache error occurred']);
}

/// Network failure when no internet connection
class NetworkFailure extends Failure {
  const NetworkFailure(
      [super.message =
          'A network error occurred. Please check your connection.']);
}

/// AI service specific failure for the Campus Oracle feature
class AIServiceFailure extends Failure {
  const AIServiceFailure(
      [super.message = 'Could not connect to Campus Oracle']);
}
