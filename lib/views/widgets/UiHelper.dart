import 'package:flutter/material.dart';

class UiHelper{

  static CustomImage({required String img}) {
    return Image.asset("assets/images/$img");
  }

  static CustomText({required String text,required Color color,required double size,required FontWeight fontweight, String? fontfamily}){
   return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontweight,
        fontFamily: fontfamily ?? 'regular'
      ),
    );
  }

  static CustomTextFields({required TextEditingController controller,required String HintText, required Icon icon}){

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF5F0476),
              Color(0xFFC60077),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(1.2), // thin inner spacing for glow
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            color: Colors.black.withOpacity(0.6), // inner field background
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.pinkAccent,
            decoration: InputDecoration(
              hintText: HintText,
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: icon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            ),
          ),
        ),

      ),
    );

  }

  static CustomButtons({required String text}) {
    return Ink(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF5F0476),
            Color(0xFFC60077),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.9), // pinkish glow
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 6), // downward soft shadow
          ),
        ],
      ),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 14), // better button height
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

}