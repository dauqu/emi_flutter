import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrCode extends StatefulWidget {
  const QrCode({Key? key}) : super(key: key);

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  final String qrData = "https://harshaweb.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 20,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        centerTitle: false,
        title: const Text('QR Code'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              //Text to be converted to QR Code
              const Text(
                "Scan this QR Code to Enroll \n new device for EMI",
                style: TextStyle(
                  fontSize: 25, 
                  fontWeight: FontWeight.bold,
                  //Underline the text
                  decoration: TextDecoration.underline,
                  ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 150,
              ),
              //Generate QR Code
              PrettyQr(
                data: qrData,
                size: 200,
                typeNumber: 5,
                roundEdges: true,
                errorCorrectLevel: QrErrorCorrectLevel.M,
                image: const NetworkImage(
                    "https://res.cloudinary.com/crunchbase-production/image/upload/c_lpad,h_256,w_256,f_auto,q_auto:eco,dpr_1/fa8nmvofinznny6rkwvf"),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
