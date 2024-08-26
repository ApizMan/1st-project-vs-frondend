import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

Widget containerstyle(String label) {
  return Row(
    children: [
      const SizedBox(width: 150),        
      Container(   
        alignment: Alignment.center,     
        width: 200,
        height: 35.0,
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ),
    ],
  );
}
