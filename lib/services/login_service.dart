import 'dart:convert'; // Necessário para json.encode e json.decode
import 'package:crud_flutter/exception/authentication_exception.dart';
import 'package:crud_flutter/models/_import.dart';
import 'package:http/http.dart' as http; // Importa o pacote http

/// Este é uma classe que faz a requisição para a API pública para o processo de
/// autenticação
///
/// API pública: https://dummyjson.com/auth/login,
/// website: https://dummyjson.com
class LoginService {
  final String _baseUrl = 'https://dummyjson.com/auth/login';

  /// Este endpoint da API pública permite fazer o processo de autenticação com o username e password
  /// para isso deves escolher uns dos utilizadores neste endpoinst "https://dummyjson.com/users"
  /// @param username
  /// @param password
  /// @returns
  Future<AuthPerson> auth(String username, String password) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return AuthPerson.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400 || response.statusCode == 401) {
      throw AuthenticationException('Falha na autenticação: ${response.statusCode} - ${response.body}');
    } else {
      throw Exception('Falha ao autenticar. Status code: ${response.statusCode}');
    }
  }
}

