import 'package:crud_flutter/util/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class _SelectOption {
  final String value;
  final String label;
  const _SelectOption({required this.value, required this.label});
}

class SelectFilter extends StatelessWidget {
  final String? value;
  final String hintText;
  final ValueChanged<String?> onValueChange;
  final FormFieldValidator<String?>? validator;

  final List<_SelectOption> _internalOptions = const [
    _SelectOption(value: "username", label: "Nome de usuário"),
    _SelectOption(value: "firstName", label: "Primeiro nome"),
    _SelectOption(value: "lastName", label: "Último nome"),
    _SelectOption(value: "email", label: "Email"),
    _SelectOption(value: "birthDate", label: "Nascimento"),
  ];

  const SelectFilter({
    super.key,
    required this.onValueChange,
    this.value,
    this.hintText = 'Selecione um campo',
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(hintText, style: GoogleFonts.quicksand(color: Colors.grey[600])),
        isExpanded: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        icon: Icon(Icons.arrow_drop_down, color: AppColors.colorIconInput),
        style: GoogleFonts.lexend(fontSize: 16, color: Colors.black87),
        onChanged: onValueChange,
        validator: validator,
        items: _internalOptions.map((option) => DropdownMenuItem<String>(
          value: option.value,
          child: Text(option.label, style: GoogleFonts.quicksand()),
        ))
            .toList(),
      ),
    );
  }
}