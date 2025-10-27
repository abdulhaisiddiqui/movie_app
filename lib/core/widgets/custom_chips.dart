import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomChips extends StatelessWidget {
  List<String> items = [];
   CustomChips({super.key,required this.items});



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF5E0189),
                  Color(0xFF000000),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.8),
                  offset: const Offset(4, 6),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Text(
                items[index] ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
