class BaseException implements Exception {
  BaseException({
    required this.error,
    required this.trace,
  });
  Object error;
  StackTrace trace;
}
