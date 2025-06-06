/// Exemplo de uma classe AuthenticationError simples, caso você não a tenha definido.
/// Se você já tiver uma em seu projeto, use-a.
class AuthenticationException implements Exception {
  final String message;

  AuthenticationException([this.message = 'Erro de autenticação desconhecido.']);

  @override
  String toString() => 'AuthenticationException: $message';
}