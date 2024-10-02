import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LabeledText extends StatelessWidget {
  final String label;

  const LabeledText(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label:  ',
      style: GoogleFonts.secularOne(
        fontSize: 15,
        color: Colors.black,
      ),
    );
  }
}

class FormFieldContainer extends StatelessWidget {
  const FormFieldContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(      
      alignment: Alignment.center,
      width: 200,
      height: 35.0,      
      child: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),        
      ),
    );
  }
}
Widget buildFormField(String label) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      LabeledText(label),           
      const FormFieldContainer(),
    ],
  );
}
