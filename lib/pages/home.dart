import 'dart:convert';

import 'package:emi_app/components/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_information/device_information.dart';
import 'package:platform_device_id/platform_device_id.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Device Info
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  var model = "";
  var serial_number = "";
  var platformVersion = "";
  var imeiNo = "";

// Profile
  late SharedPreferences prefs;
  Map user = {};
  Map emi = {};
  bool haveEmi = false;

  Future getProfile() async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      final Uri url = Uri.parse("$api/profile");
      final http.Response reponse =
          await http.get(url, headers: {"token": token});

      var data = jsonDecode(reponse.body);
      if (reponse.statusCode == 200) {
        prefs.setString('user', jsonEncode(data));
        setState(() {
          user = data;
          if (data["active_emi"] != null) haveEmi = true;
        });
      }
    } catch (e) {
      mySnackBar(context, e.toString(), type: "error");
    }
  }

  bool emiLoading = true;
  bool emipending = false;

  Future getEmiDetails() async {
    try {
      setState(() {
        emiLoading = true;
      });
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      final Uri url = Uri.parse("$api/emi/my");
      final http.Response reponse =
          await http.get(url, headers: {"token": token});

      var data = jsonDecode(reponse.body);
      // print(data);

      if (reponse.statusCode == 200) {
        if (!data["have_emis"]) {
          prefs.remove('emi');
          setState(() {
            haveEmi = false;
          });
          return;
        }

        setState(() {
          emi = data["emi"];
          emipending = data["emipending"];
        });
      }
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        emiLoading = false;
      });
    }
  }

  //=======================================
  var _deviceId = "";
  var qrData = "";

  Future<void> initPlatformState() async {
    setState(() async {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      qrData = androidInfo.fingerprint;
    });
  }

  @override
  void initState() {
    getProfile().then((data) {
      if (haveEmi) {
        getEmiDetails();
      } else {
        prefs.remove('emi');
        setState(() {
          emiLoading = false;
        });
      }
    });
    initPlatformState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Scan QR code and see your \nEMI details',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        PrettyQr(
                          data: qrData,
                          size: 100,
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
                  ],
                ),
              ),
            ),

            // Card of total amount of EMI
            Card(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Details of your current EMI',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Remaining EMI',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "13,000 INR",
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "25,000 INR",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "14,000 INR",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Total Paid',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 5,
            ),

            //Card of Device info like IMEI, MAC address, etc
            if (emipending)
              Card(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: const [
                        Text(
                          'EMI Pending',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ]),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Your EMI is pending for the month of ${emi['month']} ${emi['year']}. Please pay the EMI to continue using the device.',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Current EMI -',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            '₹ 0.00',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(5),
                            color: primaryColor,
                            child: const Text(
                              'Pay Now',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(
              height: 5,
            ),
            Card(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Device Info',
                      style: TextStyle(
                        fontSize: 15,
                        //Bold
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Serial Number',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          imeiNo,
                          style: const TextStyle(
                            fontSize: 15,
                            //Upper case
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Model',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          model,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Serial Number',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          '123456789',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Card(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Interest Details',
                      style: TextStyle(
                        fontSize: 15,
                        //Bold
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Monthly Interest',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "1,00,000",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Total Interest',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "2,00,000",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Total Interest',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "1,00,000",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 40,
            ),

            //List tile contact us
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Contact Us'),
              onTap: () {},
            ),

            //List tile about us
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Us'),
              onTap: () {},
            ),

            //List tile logout
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                prefs = await SharedPreferences.getInstance();
                prefs.remove('token');
                prefs.remove('user');
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    ));
  }
}
