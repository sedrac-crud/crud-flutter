import 'package:crud_flutter/models/auth_person.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPersonCubit extends Cubit<AuthPerson>{
  AuthPersonCubit({required AuthPerson person}): super(person);

  void setPerson(AuthPerson person) => emit(person);
}