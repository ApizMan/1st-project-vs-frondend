import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QrCodeScreen extends StatelessWidget {
  final String qrCodeUrl;

  const QrCodeScreen({super.key, required this.qrCodeUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 55, 26, 200),
        title: const Text('QR Code'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                    width: 5.0,
                  ),
                ),
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.network(qrCodeUrl,
                  fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Text('1.Please screenshot the QR Code',
                  style: GoogleFonts.dmSans(
                    color: Colors.red
                  ),
                ),
                Text('(QR Code will expire in 10 minutes)',
                  style: GoogleFonts.dmSans(
                    color: Colors.red
                  ),
                ),
                const SizedBox(height: 10),
                Text('2.Open you banking online app',
                  style: GoogleFonts.dmSans(
                    color: Colors.red
                  ),
                ),
                const SizedBox(height: 10),
                Text('3. Scan the QR code', 
                  style: GoogleFonts.dmSans(
                    color: Colors.red
                  ),
                )
              ],
            )
          ],
        )
        
      )
      
    );
  }
}
