import 'package:crud_flutter/blocks/auth_person_cubit.dart';
import 'package:crud_flutter/models/_import.dart';
import 'package:crud_flutter/services/login_service.dart';
import 'package:crud_flutter/widgets/button.dart';
import 'package:crud_flutter/widgets/input_form_text.dart';
import 'package:crud_flutter/widgets/password_form_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginService loginService;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    loginService = LoginService();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authPersonCubit  = context.watch<AuthPersonCubit>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        child: Center(
          child: Stack(
            children: [
              Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue, Colors.white,],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30, left: 30, top: 150),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 5,
                  children: [
                    Text(
                      'Faça', style: GoogleFonts.getFont('Lexend Giga', fontWeight: FontWeight.w700, fontSize: 30, color: Colors.white),
                    ),
                    Text(
                      'Autenticação', style: GoogleFonts.getFont('Lexend Giga',  fontWeight: FontWeight.w700, fontSize: 20, color: Colors.white),
                    ),
                    Expanded(child: ListView(
                      children: [
                        InputFormText(controller: _emailController, label: "Nome de usuário", prefixIcon: Icon(Icons.person, color: Colors.blue[400],)),
                        const SizedBox(height: 30,),
                        PasswordFormText(controller: _passwordController, label: "Senha",),
                        const SizedBox(height: 60,),
                        Button(onPressed: () async {
                          try {
                            AuthPerson person = await loginService.auth(
                                _emailController.text.trim(),
                                _passwordController.text.trim()
                            );
                            authPersonCubit.setPerson(person);
                            Navigator.pushReplacementNamed(context, '/page');
                          }catch(e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: const Text('Não foi possível autenticar'),
                            ));
                          }
                        },)
                      ],
                    ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
