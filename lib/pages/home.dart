import 'dart:convert';

import 'package:emi_app/components/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: emiLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : haveEmi
                ? SingleChildScrollView(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Scan QR code and see your \nEMI details',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Image.network(
                                          "https://qrcg-free-editor.qr-code-generator.com/main/assets/images/websiteQRCode_noFrame.png",
                                          width: 100,
                                          height: 100),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Remaining EMI',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        //
                                        // +

                                        emi["remaining_amount"]
                                                    .toString()
                                                    .split(".")
                                                    .length <=
                                                1
                                            ? "₹ ${emi["remaining_amount"].toString().split(".")[0]}.00"
                                            : emi["remaining_amount"]
                                                        .toString()
                                                        .split(".")[1]
                                                        .length <=
                                                    2
                                                ? "₹ ${emi["remaining_amount"].toString().split(".")[0]}.${emi["remaining_amount"].toString().split(".")[1]}"
                                                : "₹ ${emi["remaining_amount"].toString().split(".")[0]}.${emi["remaining_amount"].toString().split(".")[1].substring(0, 2)}",
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '₹ ${emi['total_amount']}',
                                        style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        '₹ ${(emi['total_amount'] + (emi["interest_rate"] * emi["time_period"]) - emi['remaining_amount']).toString()}',
                                        style: const TextStyle(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                      'Due Date - ${emi["next_emidate"]}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                        Text(
                                          '₹ ${emi["monthly_emi"]}',
                                          style: const TextStyle(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'IMEI',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        '${emi["device_id"]["imei_no"]}',
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        'MAC Address',
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
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Monthly Interest',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        '₹ ${emi["interest_rate"]}',
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Total Interest',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        '₹ ${emi["interest_rate"] * emi["time_period"]}',
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Total Interest',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        '₹ ${emi["interest_rate"] * emi["paid_installment"]}',
                                        style: const TextStyle(
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
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            )
                          ],
                        ),
                        child: const Text(
                          'You have no active EMI',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ));
  }
}
