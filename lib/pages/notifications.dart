import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List data = [
    {
      "title": "Address Updated",
      "description":
          "Your address has been updated to 123, ABC Street, XYZ City, ABC State, 123456",
    },
    {
      "title": "Order Placed",
      "description":
          "Your order has been placed successfully. Your order number is 123456",
    },
    {
      "title": "Order Shipped",
      "description": "Your order has been shipped. Your order number is 123456",
    },
    {
      "title": "Order Delivered",
      "description":
          "Your order has been delivered successfully. Your order number is 123456",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
          splashRadius: 20,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        centerTitle: false,
        title: const Text('Notifications'),
      ),
      body: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: ((context, index) {
                Map item = data[index];
                return Dismissible(
                  key: UniqueKey(),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["title"].toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            item["description"].toString(),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }))
        ],
      ),
    );
  }
}
