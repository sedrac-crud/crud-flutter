import 'package:crud_flutter/util/app_colors.dart';
import 'package:flutter/material.dart';

class InputSearch extends StatelessWidget {
  final TextEditingController controller;
  final Function() onSubmitted;
  final Function() onPressedPrefixIcon;

  const InputSearch({super.key, required this.onSubmitted, required this.controller, required this.onPressedPrefixIcon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Pesquisar usuário...',
        filled: true,
        fillColor: Colors.grey[100],
        prefixIcon: IconButton(
            onPressed: onPressedPrefixIcon,
            icon: Icon(Icons.tune, color: AppColors.colorIconInput,)
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          onPressed: onSubmitted,
          icon: Icon(Icons.search, color: AppColors.colorIconInput,),
        ),
      ),
      onSubmitted: (value) {
        onSubmitted();
      },
    );
  }
}
