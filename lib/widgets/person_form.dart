import 'package:crud_flutter/util/app_colors.dart';
import 'package:crud_flutter/widgets/line_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crud_flutter/models/person.dart';

class PersonForm extends StatefulWidget {
  final Person? initialPerson;
  final ValueChanged<Person> onSubmit;

  const PersonForm({
    super.key,
    this.initialPerson,
    required this.onSubmit,
  });

  @override
  State<PersonForm> createState() => _PersonFormState();
}

class _PersonFormState extends State<PersonForm> {
  final _formKey = GlobalKey<FormState>();
  String _selectedGender = "male";
  bool _loading = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialPerson != null) {
      _firstNameController.text = widget.initialPerson!.firstName;
      _lastNameController.text = widget.initialPerson!.lastName;
      _selectedGender = widget.initialPerson!.gender;
      _emailController.text = widget.initialPerson!.email;
      _imageController.text = widget.initialPerson!.image;
      _birthDateController.text = widget.initialPerson!.birthDate;
      _usernameController.text = widget.initialPerson!.username;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _imageController.dispose();
    _birthDateController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_birthDateController.text) ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  void _submitForm() async {
    if(_loading) return;
    setState(() { _loading = true; });
    if (_formKey.currentState?.validate() ?? false) {
      final newPerson = Person(
        id: widget.initialPerson?.id ?? 0,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        gender: _selectedGender,
        email: _emailController.text,
        image: _imageController.text,
        birthDate: _birthDateController.text,
        username: _usernameController.text,
      );
      widget.onSubmit(newPerson);
    }
    setState(() { _loading = false; });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: suffixIcon,
      ),
      keyboardType: keyboardType,
      validator: validator,
      onTap: onTap,
      readOnly: readOnly,
    );
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
            LineModalSheet(),
            const SizedBox(height: 30,),
            _buildTextField(
              controller: _firstNameController,
              labelText: 'Primeiro Nome',
              validator: (value) => value == null || value.isEmpty ? 'Por favor, insira o primeiro nome.' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _lastNameController,
              labelText: 'Último Nome',
              validator: (value) => value == null || value.isEmpty ? 'Por favor, insira o último nome.' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                labelText: 'Gênero',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items: const [
                DropdownMenuItem(value: 'male', child: Text('Masculino')),
                DropdownMenuItem(value: 'female', child: Text('Feminino')),
                DropdownMenuItem(value: 'other', child: Text('Outro')),
              ],
              onChanged: (value) {
                if(value != null) {
                  setState(() { _selectedGender = value; });
                }
              },
              validator: (value) => value == null || value.isEmpty ? 'Por favor, selecione o gênero.' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
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
            _buildTextField(
              controller: _imageController,
              labelText: 'URL da Imagem de Perfil',
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Por favor, insira a URL da imagem.';
                if (!value.startsWith('http://') && !value.startsWith('https://')) return 'URL inválida (deve começar com http:// ou https://)';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _birthDateController,
              labelText: 'Data de Nascimento (YYYY-MM-DD)',
              readOnly: true,
              onTap: () => _selectBirthDate(context),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectBirthDate(context),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Por favor, insira a data de nascimento.';
                if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) return 'Formato de data inválido (YYYY-MM-DD)';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _usernameController,
              labelText: 'Nome de Usuário',
              validator: (value) => value == null || value.isEmpty ? 'Por favor, insira o nome de usuário.' : null,
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
              child: Text(widget.initialPerson == null ? 'Criar Usuário' : 'Atualizar Usuário', style: GoogleFonts.lexend(fontSize: 14),),
            ),
          ],
        ),
      ),
    );
  }
}