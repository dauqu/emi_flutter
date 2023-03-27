import 'dart:convert';

import 'package:emi_app/components/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Emi extends StatefulWidget {
  const Emi({super.key});

  @override
  State<Emi> createState() => _EmiState();
}

class _EmiState extends State<Emi> {
  var selected = 5;

  //List of JSOn data
  // List data = [
  //   {
  //     "id": 1,
  //     "totalAmount": 2345,
  //     "date": "12 Sep 2021 12:00 AM",
  //     "status": "Paid",
  //     "selected": false,
  //     "icon": "credit_card"
  //   },
  //   {
  //     "id": 2,
  //     "totalAmount": 2345,
  //     "date": "12 Sep 2021 12:00 AM",
  //     "status": "Paid",
  //     "selected": false,
  //     "icon": "credit_card"
  //   },
  //   {
  //     "id": 3,
  //     "totalAmount": 2345,
  //     "date": "12 Sep 2021 12:00 AM",
  //     "status": "Paid",
  //     "selected": false,
  //     "icon": "credit_card"
  //   },
  //   {
  //     "id": 4,
  //     "totalAmount": 2345,
  //     "date": "12 Sep 2021 12:00 AM",
  //     "status": "Paid",
  //     "selected": false,
  //     "icon": "credit_card"
  //   },
  //   {
  //     "id": 5,
  //     "totalAmount": 2345,
  //     "date": "12 Sep 2021 12:00 AM",
  //     "status": "Paid",
  //     "selected": false,
  //     "icon": "credit_card"
  //   },
  //   {
  //     "id": 6,
  //     "totalAmount": 2345,
  //     "date": "12 Sep 2021 12:00 AM",
  //     "status": "Verifing",
  //     "selected": false,
  //     "icon": "credit_card"
  //   },
  //   {
  //     "id": 7,
  //     "totalAmount": 2345,
  //     "date": "12 Sep 2021 12:00 AM",
  //     "status": "Pending",
  //     "selected": false,
  //     "icon": "credit_card"
  //   },
  //   {
  //     "id": 8,
  //     "totalAmount": 2345,
  //     "date": "12 Sep 2021 12:00 AM",
  //     "status": "Pending",
  //     "selected": false,
  //     "icon": "credit_card"
  //   },
  //   {
  //     "id": 9,
  //     "totalAmount": 2345,
  //     "date": "12 Sep 2021 12:00 AM",
  //     "status": "Pending",
  //     "selected": false,
  //     "icon": "credit_card"
  //   },
  //   {
  //     "id": 10,
  //     "totalAmount": 2345,
  //     "date": "12 Sep 2021 12:00 AM",
  //     "status": "Pending",
  //     "selected": false,
  //     "icon": "credit_card"
  //   },
  // ];

  late SharedPreferences prefs;
  List history = [];
  Map emi = {};
  bool haveEmi = false;
  bool emi_loading = true;

  Future getEMIHistory() async {
    setState(() {
      emi_loading = true;
    });
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token')!;

      final Uri url = Uri.parse('$api/emi/my');

      final http.Response reponse =
          await http.get(url, headers: {"token": token});

      var data = jsonDecode(reponse.body);
      // print(data);

      if (reponse.statusCode == 200 && data["have_emis"]) {
        setState(() {
          emi = data['emi'];
          haveEmi = true;
          List historyData = data["emi"]['history'];
          history = historyData.reversed.toList();
        });
      } else {
        setState(() {
          haveEmi = false;
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        emi_loading = false;
      });
    }
  }

  @override
  void initState() {
    getEMIHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //Make EMI paid and EMI pending as a list
        body: emi_loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          selected = index;
                        });
                      },
                      selectedTileColor: Colors.black,
                      selected: selected == index,
                      leading: const Icon(Icons.wallet),
                      title: Text(
                        //Total amount of the EMI
                        '₹ ${history[index]['paid_amount']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF565656),
                        ),
                      ),
                      subtitle: Text(toDateTime(history[index]["paid_date"]),
                          style: TextStyle(
                            color: Color(0xFF565656),
                          )),
                      //Trailing is the right side of the list status of the EMI
                      trailing: Container(
                        // 100 px width
                        width: 80,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          //If number is even then EMI is paid else EMI is pending
                          "PAID",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }));
  }
}
