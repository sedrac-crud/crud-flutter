import 'package:crud_flutter/app.dart';
import 'package:crud_flutter/blocks/auth_person_cubit.dart';
import 'package:crud_flutter/models/_import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthPersonCubit(person: AuthPerson.init() ))
      ],
      child: const CrudPersonApp()
  ));
}
