import 'package:crud_flutter/util/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

InputDecoration buildInputDecoration(String labelText, {Widget? suffixIcon}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: GoogleFonts.quicksand(color: AppColors.colorIconInput),
    hintStyle: GoogleFonts.quicksand(color: Colors.grey[400]),
    filled: true,
    fillColor: Colors.grey[50],
    contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.colorIconInput.withAlpha(50), width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.colorIconInput, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.red, width: 2.0),
    ),
    suffixIcon: suffixIcon,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
  );
}

Widget buildTextField({
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
    decoration: buildInputDecoration(labelText, suffixIcon: suffixIcon),
    keyboardType: keyboardType,
    validator: validator,
    onTap: onTap,
    readOnly: readOnly,
    style: GoogleFonts.quicksand(fontSize: 16, color: Colors.black87),
    cursorColor: AppColors.colorIconInput,
  );
}