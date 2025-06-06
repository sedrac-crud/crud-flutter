class DeleteException implements Exception {
  final String message;
  DeleteException([this.message = 'Não foi possível realizar a operação de eliminação.']);
  @override
  String toString() => 'DeleteException: $message';
}