import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Emi extends StatefulWidget {
  const Emi({super.key});

  @override
  State<Emi> createState() => _EmiState();
}

class _EmiState extends State<Emi> {
  var selected = 5;

  //List of JSOn data
  List data = [
    {
      "id": 1,
      "totalAmount": 2345,
      "date": "12 Sep 2021 12:00 AM",
      "status": "Paid",
      "selected": false,
      "icon": "credit_card"
    },
    {
      "id": 2,
      "totalAmount": 2345,
      "date": "12 Sep 2021 12:00 AM",
      "status": "Paid",
      "selected": false,
      "icon": "credit_card"
    },
    {
      "id": 3,
      "totalAmount": 2345,
      "date": "12 Sep 2021 12:00 AM",
      "status": "Paid",
      "selected": false,
      "icon": "credit_card"
    },
    {
      "id": 4,
      "totalAmount": 2345,
      "date": "12 Sep 2021 12:00 AM",
      "status": "Paid",
      "selected": false,
      "icon": "credit_card"
    },
    {
      "id": 5,
      "totalAmount": 2345,
      "date": "12 Sep 2021 12:00 AM",
      "status": "Paid",
      "selected": false,
      "icon": "credit_card"
    },
    {
      "id": 6,
      "totalAmount": 2345,
      "date": "12 Sep 2021 12:00 AM",
      "status": "Verifing",
      "selected": false,
      "icon": "credit_card"
    },
    {
      "id": 7,
      "totalAmount": 2345,
      "date": "12 Sep 2021 12:00 AM",
      "status": "Pending",
      "selected": false,
      "icon": "credit_card"
    },
    {
      "id": 8,
      "totalAmount": 2345,
      "date": "12 Sep 2021 12:00 AM",
      "status": "Pending",
      "selected": false,
      "icon": "credit_card"
    },
    {
      "id": 9,
      "totalAmount": 2345,
      "date": "12 Sep 2021 12:00 AM",
      "status": "Pending",
      "selected": false,
      "icon": "credit_card"
    },
    {
      "id": 10,
      "totalAmount": 2345,
      "date": "12 Sep 2021 12:00 AM",
      "status": "Pending",
      "selected": false,
      "icon": "credit_card"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //Make EMI paid and EMI pending as a list
        body: ListView.builder(
            itemCount: data.length,
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
                    '₹ ${data[index]['totalAmount']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF565656),
                    ),
                  ),
                  subtitle: const Text('12 Sep 2021 12:00 AM',
                      style: TextStyle(
                        color: Color(0xFF565656),
                      )),
                  //Trailing is the right side of the list status of the EMI
                  trailing: Container(
                    // 100 px width
                    width: 80,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: data[index]['status'] == 'Paid'
                          ? Colors.green
                          : Colors.red,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      //If number is even then EMI is paid else EMI is pending
                      data[index]['status'].toUpperCase(),
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
