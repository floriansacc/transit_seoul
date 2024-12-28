class ApiException implements Exception {
  /// 서버에서 200이 아닐 때 쓰이는 것
  final int? statusCode;
  final dynamic message;

  /// Creates a new ApiException with an optional error [message].
  const ApiException(this.statusCode, this.message);

  @override
  String toString() =>
      'ApiException: Status code $statusCode - Message: $message';
}
