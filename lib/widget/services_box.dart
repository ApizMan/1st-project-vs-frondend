import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceBox extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onPressed;
  final Key? key;

  // ignore: use_key_in_widget_constructors
  const ServiceBox({required this.image, required this.onPressed,required this.label, this.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 50,                        
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(20.0),              
            ),
            child: Image.asset(
              image,
              width: 50,
              height: 50,                           
            ),
          ),
          const SizedBox(height: 10), 
          Container(
            width: 100,
            padding: const EdgeInsets.all(8),           
            child:  Text(
              label,              
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),              
            ),
          ),
        ],
      ),
    );
  }
}
