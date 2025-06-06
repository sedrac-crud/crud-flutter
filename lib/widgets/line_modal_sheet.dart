import 'package:flutter/material.dart';

class LineModalSheet extends StatelessWidget {
  const LineModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>  Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.only(top: 50),
        width: 100,
        height: 13,
        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(50),),
      ),
    );
  }
}
