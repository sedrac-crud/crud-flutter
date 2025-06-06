import 'package:flutter/material.dart';

class ImageOval extends StatelessWidget {
  final String image;

  const ImageOval({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.network(
        image,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return  Icon(Icons.broken_image, size: 50, color: Colors.grey);
        },
      ),
    );
  }
}
