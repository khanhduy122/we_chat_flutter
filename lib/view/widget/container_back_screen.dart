import 'package:flutter/material.dart';
import 'package:we_chat/conpoment/app_color.dart';

class containerBackScreen extends StatelessWidget {
  const containerBackScreen({super.key, required this.color, });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        child: Icon(Icons.arrow_back_ios, color: color, size: 24,),
      ),
    );
  }
}