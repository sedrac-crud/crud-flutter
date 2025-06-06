import 'package:crud_flutter/util/app_colors.dart';
import 'package:crud_flutter/widgets/line_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crud_flutter/models/auth_person.dart';
import 'package:crud_flutter/util/inputs_styles.dart';

class AuthPersonForm extends StatefulWidget {
  final AuthPerson initialAuthPerson;
  final ValueChanged<AuthPerson> onSubmit;

  const AuthPersonForm({
    super.key,
    required this.initialAuthPerson,
    required this.onSubmit,
  });

  @override
  State<AuthPersonForm> createState() => _AuthPersonFormState();
}

class _AuthPersonFormState extends State<AuthPersonForm> {
  final _formKey = GlobalKey<FormState>();
  String _selectedGender = "male";
  bool _loading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
      _usernameController.text = widget.initialAuthPerson.username;
      _emailController.text = widget.initialAuthPerson.email;
      _firstNameController.text = widget.initialAuthPerson.firstName;
      _lastNameController.text = widget.initialAuthPerson.lastName;
      _selectedGender = widget.initialAuthPerson.gender;
      _imageController.text = widget.initialAuthPerson.image;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_loading) return;
    setState(() { _loading = true; });

    if (_formKey.currentState?.validate() ?? false) {
      final newAuthPerson = AuthPerson(
        id: widget.initialAuthPerson.id,
        accessToken: widget.initialAuthPerson.accessToken,
        refreshToken: widget.initialAuthPerson.refreshToken,
        username: _usernameController.text,
        email: _emailController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        gender: _selectedGender,
        image: _imageController.text,
      );
      widget.onSubmit(newAuthPerson);
    }
    setState(() { _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const LineModalSheet(),
            const SizedBox(height: 30),
            buildTextField(
              controller: _usernameController,
              labelText: 'Nome de Usuário',
              validator: (value) => value == null || value.isEmpty ? 'Por favor, insira o nome de usuário.' : null,
            ),
            const SizedBox(height: 16),
            buildTextField(
              controller: _emailController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Por favor, insira o email.';
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Por favor, insira um email válido.';
                return null;
              },
            ),
            const SizedBox(height: 16),
            buildTextField(
              controller: _firstNameController,
              labelText: 'Primeiro Nome',
              validator: (value) => value == null || value.isEmpty ? 'Por favor, insira o primeiro nome.' : null,
            ),
            const SizedBox(height: 16),
            buildTextField(
              controller: _lastNameController,
              labelText: 'Último Nome',
              validator: (value) => value == null || value.isEmpty ? 'Por favor, insira o último nome.' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: buildInputDecoration('Gênero'),
              items: const [
                DropdownMenuItem(value: 'male', child: Text('Masculino')),
                DropdownMenuItem(value: 'female', child: Text('Feminino')),
                DropdownMenuItem(value: 'other', child: Text('Outro')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() { _selectedGender = value; });
                }
              },
              validator: (value) => value == null || value.isEmpty ? 'Por favor, selecione o gênero.' : null,
              style: GoogleFonts.quicksand(fontSize: 16, color: Colors.black87),
              icon: Icon(Icons.arrow_drop_down, color: AppColors.colorIconInput),
            ),
            const SizedBox(height: 16),
            buildTextField(
              controller: _imageController,
              labelText: 'URL da Imagem de Perfil',
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Por favor, insira a URL da imagem.';
                if (!value.startsWith('http://') && !value.startsWith('https://')) return 'URL inválida (deve começar com http:// ou https://)';
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                backgroundColor: AppColors.colorIconInput,
                foregroundColor: Colors.white,
              ),
              child: _loading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ) : Text('Atualizar Perfil', style: GoogleFonts.lexend(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}