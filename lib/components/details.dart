import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                //Full width
                width: double.infinity,
                child: Card(
                    elevation: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Account Details",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF565656),
                            ),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 2),
                            child: ListTile(
                              tileColor: Color(0xE2FFFFFF),
                              leading: Icon(Icons.wallet, color: Colors.grey),
                              title: Text(
                                'Total Amount Paid',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF565656),
                                    fontWeight: FontWeight.w800),
                              ),
                              subtitle: Text(
                                'Rs. 1000',
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xFF565656)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 2),
                            child: ListTile(
                              tileColor: Color(0xE2FFFFFF),
                              leading: Icon(Icons.business, color: Colors.grey),
                              title: Text(
                                'Shipping Address',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF565656),
                                    fontWeight: FontWeight.w800),
                              ),
                              subtitle: Text(
                                'No. 1, 2nd Street, 3rd Avenue, 4th Block, 5th Ward, 6th District',
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xFF565656)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const ListTile(
                            dense: true,
                            title: Text(
                              'Is Email Verified?',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF565656),
                                  fontWeight: FontWeight.w800),
                            ),
                            trailing: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                          ),
                          ListTile(
                            dense: true,
                            title: const Text(
                              'Is Phone Verified?',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF565656),
                                  fontWeight: FontWeight.w800),
                            ),
                            subtitle: const Text(
                              'Click to verify your phone number',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 211, 6, 6)),
                            ),
                            trailing: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      elevation: 0,
                                      title: const Text('Verify Phone Number'),
                                      content: Container(
                                        height: 150,
                                        child: Column(
                                          children: const [
                                            Text(
                                                'A verification code will be sent to your phone number'),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            TextField(
                                              decoration: InputDecoration(
                                                  //Bottom border
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelText: 'OTP'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel')),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Verify'))
                                      ],
                                    );
                                  });
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          //Upload id proof
                          const ListTile(
                            dense: true,
                            title: Text(
                              'Upload ID Proof',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF565656),
                                  fontWeight: FontWeight.w800),
                            ),
                            subtitle: Text(
                              'Click to upload your ID proof',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 211, 6, 6)),
                            ),
                            trailing: Icon(
                              Icons.upload_file,
                              color: Colors.blue,
                            ),
                          ),

                          //My Ratings
                          const SizedBox(
                            height: 15,
                          ),
                          const ListTile(
                              dense: true,
                              title: Text(
                                'My Ratings',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF565656),
                                    fontWeight: FontWeight.w800),
                              ),
                              subtitle: Text(
                                '4.5/5',
                              ),
                              trailing: Icon(
                                Icons.star,
                                color: Colors.yellow,
                              )),

                          //CHange Password
                          const SizedBox(
                            height: 15,
                          ),
                          ListTile(
                            dense: true,
                            title: const Text(
                              'Change Password',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF565656),
                                  fontWeight: FontWeight.w800),
                            ),
                            subtitle: const Text(
                              'Click to change your password',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 211, 6, 6)),
                            ),
                            trailing: const Icon(
                              Icons.lock,
                              color: Colors.blue,
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      elevation: 0,
                                      title: const Text('Change Password'),
                                      content: Container(
                                        height: 200,
                                        child: Column(
                                          children: const [
                                            TextField(
                                              decoration: InputDecoration(
                                                  hintText: 'Old Password'),
                                            ),
                                            TextField(
                                              decoration: InputDecoration(
                                                  hintText: 'New Password'),
                                            ),
                                            TextField(
                                              decoration: InputDecoration(
                                                  hintText:
                                                      'Confirm New Password'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel')),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Change')),
                                      ],
                                    );
                                  });
                            },
                          ),

                          //Logout
                          const SizedBox(
                            height: 15,
                          ),
                          const ListTile(
                            dense: true,
                            title: Text(
                              'Support',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF565656),
                                  fontWeight: FontWeight.w800),
                            ),
                            subtitle: Text(
                              'Help and Support',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF06D35F)),
                            ),
                            trailing: Icon(Icons.support_agent),
                          ),
                        ],
                      ),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                //Full width
                width: double.infinity,
                child: Text("Term & Conditions",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF565656),
                    ),
                    textAlign: TextAlign.center),
              )
            ],
          )),
    );
  }
}
