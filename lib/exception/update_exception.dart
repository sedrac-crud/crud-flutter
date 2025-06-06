class UpdateException implements Exception {
  final String message;
  UpdateException([this.message = 'Não foi possível realizar a operação de edição.']);
  @override
  String toString() => 'UpdateException: $message';
}