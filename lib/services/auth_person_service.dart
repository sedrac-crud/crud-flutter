import 'dart:convert';
import 'package:crud_flutter/exception/update_exception.dart';
import 'package:crud_flutter/models/_import.dart';
import 'package:http/http.dart' as http;

/// Este é uma classe que faz a requisição para a API pública para o modificacar as informações do usuário
/// auenticado
/// API pública: https://dummyjson.com/users,
/// website: https://dummyjson.com
class AuthPersonService {
  final String _baseUrl = 'https://dummyjson.com/users';
  /// Este endpoint serve para edição de um usuário.
  /// @param person O objeto Person com os dados atualizados e o ID.
  /// @returns O usuário atualizado com sucesso.
  Future<AuthPerson> update(AuthPerson person) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/${person.id}'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'firstName': person.firstName,
        'lastName': person.lastName,
        'username': person.username,
        'gender': person.gender,
        'image': person.image,
      }),
    );

    final map = jsonDecode(response.body) as Map<String, dynamic>;

    map['refreshToken'] = person.refreshToken;
    map['accessToken'] = person.accessToken;

    if (response.statusCode == 200) {
      return AuthPerson.fromJson(map);
    } else {
      throw UpdateException("Não foi possível a realização desta operação de edição: ${response.statusCode} - ${response.body}");
    }
  }

}