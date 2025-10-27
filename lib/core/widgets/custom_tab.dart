import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget{
  final String text;
  final bool isActive;

  CustomTab({
    super.key,
    required this.text,
    required this.isActive
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: isActive ? Color(0XFF9500DC) : Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

