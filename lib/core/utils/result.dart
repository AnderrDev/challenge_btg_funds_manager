/// Sealed class for functional error handling.
///
/// Provides a type-safe way to handle success and failure cases
/// without using exceptions in the business logic layer.
sealed class Result<T> {
  const Result();
}

/// Represents a successful operation with [data].
final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

/// Represents a failed operation with an error [message].
final class Failure<T> extends Result<T> {
  const Failure(this.message);
  final String message;
}
