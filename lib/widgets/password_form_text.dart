import 'package:crud_flutter/util/app_colors.dart';
import 'package:crud_flutter/widgets/input_form_text.dart';
import 'package:flutter/material.dart';

class PasswordFormText extends StatefulWidget {
  final TextEditingController? controller;
  final String label;

  const PasswordFormText({super.key, required this.label, this.controller});

  @override
  State<PasswordFormText> createState() => _PasswordFormTextState();
}

class _PasswordFormTextState extends State<PasswordFormText> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return InputFormText(
      controller: widget.controller,
      label: widget.label,
      keyboardType: TextInputType.visiblePassword,
      prefixIcon: Icon(Icons.key, color:AppColors.colorIconInput ),
      obscureText: _obscureText,
      suffixIcon: IconButton(onPressed: (){
        setState(() { _obscureText = !_obscureText;});
      }, icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: AppColors.colorIconInput
      )),
    );
  }
}
