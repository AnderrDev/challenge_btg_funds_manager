import 'package:equatable/equatable.dart';

/// Sealed class for functional error handling.
///
/// Provides a type-safe way to handle success and failure cases
/// without using exceptions in the business logic layer.
sealed class Result<T> extends Equatable {
  const Result();

  @override
  List<Object?> get props => [];
}

/// Represents a successful operation with [data].
final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;

  @override
  List<Object?> get props => [data];
}

/// Represents a failed operation with an error [message].
final class Failure<T> extends Result<T> {
  const Failure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
