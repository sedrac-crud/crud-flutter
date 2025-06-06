import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputFormText extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;

  const InputFormText({super.key, required this.label, this.prefixIcon, this.keyboardType, this.obscureText = false, this.suffixIcon, this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.getFont('Quicksand', fontWeight: FontWeight.w500),),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: keyboardType,
          obscureText: obscureText,
        ),
      ],
    );
  }
}
