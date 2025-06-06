import 'person.dart';

class PersonPageable {
  final List<Person> users;
  final int total;
  final int skip;
  final int limit;

  PersonPageable({
    required this.users,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory PersonPageable.fromJson(Map<String, dynamic> json) {
    final List<dynamic> usersJson = json['users'] as List<dynamic>;
    final List<Person> usersList = usersJson.map((userJson) => Person.fromJson(userJson as Map<String, dynamic>)).toList();

    return PersonPageable(
      users: usersList,
      total: json['total'] as int,
      skip: json['skip'] as int,
      limit: json['limit'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users': users.map((user) => user.toJson()).toList(),
      'total': total,
      'skip': skip,
      'limit': limit,
    };
  }
}