class Person {
  final int id;
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String image;
  final String birthDate;
  final String username;

  Person({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.image,
    required this.birthDate,
    required this.username,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      gender: json['gender'] as String,
      email: json['email'] as String,
      image: json['image'] as String,
      birthDate: json['birthDate'] as String,
      username: json['username'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'email': email,
      'image': image,
      'birthDate': birthDate,
      'username': username,
    };
  }
}