import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function() onPressed;
  const Button({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 15),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text("Confirma", style: TextStyle(color: Colors.white),),
    );
  }
}
