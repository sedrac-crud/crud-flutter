import 'dart:convert';
import 'package:crud_flutter/exception/delete_exception.dart';
import 'package:crud_flutter/exception/update_exception.dart';
import 'package:crud_flutter/models/_import.dart';
import 'package:http/http.dart' as http;

/// Este é uma classe que faz a requisição para a API pública para trazer os usuários
/// aqui estão todas as operações de CRUD, ou seja, o endpoint para criar, editar e eliminar
/// os usuários.
///
/// API pública: https://dummyjson.com/users,
/// website: https://dummyjson.com
class PersonService {
  final String _baseUrl = 'https://dummyjson.com/users';

  /// Esta rota traz todos os usuários
  /// @returns Os resultados em uma paginação onde o atributo users é uma lista de usuários
  Future<PersonPageable> getPageable() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      return PersonPageable.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception("Não foi possível a realização desta operação: ${response.statusCode}");
    }
  }

  /// Esta rota traz todos os usuários filtrados
  /// @param field O campo para filtrar (ex: 'firstName')
  /// @param value O valor para o filtro (ex: 'John')
  /// @returns Os resultados em uma paginação onde o atributo users é uma lista de usuários
  Future<PersonPageable> getPageableFilter(String field, String value) async {
    final Uri uri = Uri.parse('$_baseUrl/filter?key=$field&value=$value');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return PersonPageable.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception("Não foi possível a realização desta operação de filtro: ${response.statusCode}");
    }
  }

  /// Este endpoint serve para criação de um usuário, usando uma classe (Person) que representa
  /// as informações que devem ser atribuídas a um utilizador segundo a API pública.
  /// @param person O objeto Person a ser criado
  /// @returns O usuário criado com sucesso
  Future<Person> store(Person person) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/add'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'birthDate': person.birthDate,
        'firstName': person.firstName,
        'lastName': person.lastName,
        'username': person.username,
        'gender': person.gender,
        'image': person.image,
        // Inclua outros campos necessários pela API ao criar
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Person.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception("Não foi possível a realização desta operação de criação: ${response.statusCode} - ${response.body}");
    }
  }

  /// Este endpoint serve para edição de um usuário.
  /// @param person O objeto Person com os dados atualizados e o ID.
  /// @returns O usuário atualizado com sucesso.
  Future<Person> update(Person person) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/${person.id}'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'birthDate': person.birthDate,
        'firstName': person.firstName,
        'lastName': person.lastName,
        'username': person.username,
        'gender': person.gender,
        'image': person.image,
      }),
    );

    if (response.statusCode == 200) {
      return Person.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw UpdateException("Não foi possível a realização desta operação de edição: ${response.statusCode} - ${response.body}");
    }
  }

  /// Este endpoint serve para eliminação de um usuário.
  /// @param person O objeto Person com o ID do usuário a ser eliminado.
  /// @returns O usuário eliminado com sucesso (ou uma confirmação).
  Future<Person> delete(Person person) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/${person.id}'),
    );

    if (response.statusCode == 200) {
      // A API dummyjson retorna o objeto do usuário excluído.
      return Person.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw DeleteException("Não foi possível a realização desta operação de eliminação: ${response.statusCode} - ${response.body}");
    }
  }

  /// Este é um método que serve para acessar os outros métodos consoante o parâmetro de ação
  /// que indica qual ação para realizar para manipulação das informações.
  /// @param person O objeto Person a ser manipulado.
  /// @param action A ação a ser realizada ('CREATE', 'DELETE', 'UPDATE').
  /// @returns O usuário que sofreu a ação.
  Future<Person> action(Person person, String action) async {
    switch (action) {
      case "CREATE":
        return await store(person);
      case "UPDATE":
        return await update(person);
      case "DELETE": // Adicionado o case para DELETE explicitamente
        return await delete(person);
      default:
        throw ArgumentError("Ação inválida: $action. As ações permitidas são 'CREATE', 'UPDATE', 'DELETE'.");
    }
  }
}